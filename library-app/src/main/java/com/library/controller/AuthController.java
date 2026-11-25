package com.library.controller;

import com.library.config.AuthInterceptor;
import com.library.model.Loan;
import com.library.model.Member;
import com.library.service.LibraryOpsService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Controller
public class AuthController {

    private final LibraryOpsService libraryOpsService;

    public AuthController(LibraryOpsService libraryOpsService) {
        this.libraryOpsService = libraryOpsService;
    }

    @GetMapping("/login")
    public String showLogin(@RequestParam(required = false) String next, Model model) {
        model.addAttribute("nextUrl", next != null && next.startsWith("/") ? next : "/my-library");
        model.addAttribute("pageTitle", "Member Sign In");
        return "auth/login";
    }

    @PostMapping("/login")
    public String doLogin(@RequestParam String email,
                          @RequestParam String password,
                          @RequestParam(required = false, defaultValue = "/my-library") String next,
                          HttpSession session,
                          RedirectAttributes redirectAttributes) {
        Optional<Member> memberOpt = libraryOpsService.authenticate(email, password);
        if (memberOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Invalid email or password (or account suspended).");
            return "redirect:/login";
        }
        Member member = memberOpt.get();
        session.setAttribute(AuthInterceptor.SESSION_MEMBER_ID, member.getId());
        libraryOpsService.logActivity("MEMBER_LOGIN", "MEMBER", member.getFullName(),
                "Signed in to " + (member.isAdmin() ? "Admin & Member" : "Member") + " portal");
        redirectAttributes.addFlashAttribute("successMessage", "Welcome back, " + member.getFullName() + "!");
        String target = (next != null && next.startsWith("/") && !next.startsWith("//")) ? next : "/my-library";
        return "redirect:" + target;
    }

    @PostMapping("/demo-login")
    public String demoMemberLogin(@RequestParam(required = false, defaultValue = "/my-library") String next,
                                  HttpSession session,
                                  RedirectAttributes redirectAttributes) {
        Member demo = libraryOpsService.findMemberByEmail("reader@library.dev")
                .orElseThrow(() -> new IllegalStateException("Demo reader account not found"));
        session.setAttribute(AuthInterceptor.SESSION_MEMBER_ID, demo.getId());
        redirectAttributes.addFlashAttribute("successMessage", "Signed in as Demo Reader (" + demo.getFullName() + ")!");
        String target = (next != null && next.startsWith("/") && !next.startsWith("//")) ? next : "/my-library";
        return "redirect:" + target;
    }

    @GetMapping("/register")
    public String showRegister(Model model) {
        model.addAttribute("pageTitle", "Create Library Card");
        return "auth/register";
    }

    @PostMapping("/register")
    public String doRegister(@RequestParam String fullName,
                             @RequestParam String email,
                             @RequestParam String password,
                             @RequestParam(required = false, defaultValue = "STANDARD") String tier,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        if (fullName == null || fullName.trim().length() < 2) {
            redirectAttributes.addFlashAttribute("errorMessage", "Please enter your full name.");
            return "redirect:/register";
        }
        if (password == null || password.length() < 6) {
            redirectAttributes.addFlashAttribute("errorMessage", "Password must be at least 6 characters.");
            return "redirect:/register";
        }
        try {
            Member member = libraryOpsService.registerMember(fullName, email, password, tier);
            session.setAttribute(AuthInterceptor.SESSION_MEMBER_ID, member.getId());
            redirectAttributes.addFlashAttribute("successMessage",
                    "Welcome to Athenaeum, " + member.getFullName() + "! Your " + member.getMembershipTier() + " card is active.");
            return "redirect:/my-library";
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("errorMessage", ex.getMessage());
            return "redirect:/register";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session, RedirectAttributes redirectAttributes) {
        session.invalidate();
        redirectAttributes.addFlashAttribute("successMessage", "You have been signed out.");
        return "redirect:/";
    }

    // =====================================================
    // Member Self-Service Portal (/my-library)
    // =====================================================

    @GetMapping("/my-library")
    public String myLibrary(HttpServletRequest request, Model model) {
        Member currentUser = (Member) request.getAttribute("currentUser");
        libraryOpsService.refreshOverdueLoans();
        List<Loan> allLoans = libraryOpsService.getLoansForMember(currentUser.getId());
        List<Loan> activeLoans = allLoans.stream()
                .filter(l -> !"RETURNED".equalsIgnoreCase(l.getStatus()))
                .collect(Collectors.toList());
        List<Loan> pastLoans = allLoans.stream()
                .filter(l -> "RETURNED".equalsIgnoreCase(l.getStatus()))
                .collect(Collectors.toList());

        model.addAttribute("member", currentUser);
        model.addAttribute("activeLoans", activeLoans);
        model.addAttribute("pastLoans", pastLoans);
        model.addAttribute("readingList", libraryOpsService.getReadingList(currentUser.getId()));
        model.addAttribute("pageTitle", "My Library");
        return "member/dashboard";
    }

    @PostMapping("/my-library/return/{loanId}")
    public String returnMyLoan(@PathVariable Long loanId,
                               HttpServletRequest request,
                               RedirectAttributes redirectAttributes) {
        Member currentUser = (Member) request.getAttribute("currentUser");
        libraryOpsService.returnBook(loanId, currentUser.getFullName());
        redirectAttributes.addFlashAttribute("successMessage", "Book returned successfully. Thank you!");
        return "redirect:/my-library";
    }

    @PostMapping("/my-library/renew/{loanId}")
    public String renewMyLoan(@PathVariable Long loanId,
                              HttpServletRequest request,
                              RedirectAttributes redirectAttributes) {
        Member currentUser = (Member) request.getAttribute("currentUser");
        try {
            libraryOpsService.renewLoan(loanId, 7, currentUser.getFullName());
            redirectAttributes.addFlashAttribute("successMessage", "Loan extended by 7 days!");
        } catch (IllegalStateException ex) {
            redirectAttributes.addFlashAttribute("errorMessage", ex.getMessage());
        }
        return "redirect:/my-library";
    }

    @PostMapping("/my-library/reading-list/remove/{bookId}")
    public String removeBookmark(@PathVariable Long bookId,
                                 HttpServletRequest request,
                                 RedirectAttributes redirectAttributes) {
        Member currentUser = (Member) request.getAttribute("currentUser");
        libraryOpsService.toggleReadingList(currentUser.getId(), bookId);
        redirectAttributes.addFlashAttribute("successMessage", "Removed book from your Reading List.");
        return "redirect:/my-library";
    }
}

