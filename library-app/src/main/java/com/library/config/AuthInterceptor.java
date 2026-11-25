package com.library.config;

import com.library.model.Member;
import com.library.repository.MemberRepository;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@Component
public class AuthInterceptor implements HandlerInterceptor {

    public static final String SESSION_MEMBER_ID = "LOGGED_IN_MEMBER_ID";

    private final MemberRepository memberRepository;

    public AuthInterceptor(MemberRepository memberRepository) {
        this.memberRepository = memberRepository;
    }

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String uri = request.getRequestURI();
        String ctx = request.getContextPath();
        String path = uri.startsWith(ctx) ? uri.substring(ctx.length()) : uri;

        HttpSession session = request.getSession(false);
        Member currentUser = null;
        if (session != null && session.getAttribute(SESSION_MEMBER_ID) instanceof Long) {
            Long memberId = (Long) session.getAttribute(SESSION_MEMBER_ID);
            currentUser = memberRepository.findById(memberId).filter(Member::getActive).orElse(null);
            if (currentUser == null) {
                session.removeAttribute(SESSION_MEMBER_ID);
            }
        }

        request.setAttribute("currentUser", currentUser);
        request.setAttribute("currentPath", path);

        // Protect /admin/** routes except /admin/login and /admin/demo-login
        if (path.startsWith("/admin")
                && !path.equals("/admin/login")
                && !path.equals("/admin/demo-login")) {
            if (currentUser == null || !currentUser.isAdmin()) {
                response.sendRedirect(ctx + "/admin/login?required=true");
                return false;
            }
        }

        // Protect /my-library routes
        if (path.startsWith("/my-library") && currentUser == null) {
            response.sendRedirect(ctx + "/login?next=" + path);
            return false;
        }

        return true;
    }
}

