package com.library.controller;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.test.web.servlet.MockMvc;

import static org.hamcrest.Matchers.containsString;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
@DisplayName("Web, Search, E-Reader & Admin RBAC Integration Tests")
class LibraryWebIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    @DisplayName("Public routes, live Cmd+K search API, and E-Reader preview API return 200 OK")
    void testPublicRoutesAndApis() throws Exception {
        mockMvc.perform(get("/")).andExpect(status().isOk()).andExpect(view().name("index"));
        mockMvc.perform(get("/books")).andExpect(status().isOk()).andExpect(view().name("books/list"));
        mockMvc.perform(get("/books/joined")).andExpect(status().isOk()).andExpect(view().name("books/joinedView"));
        mockMvc.perform(get("/authors")).andExpect(status().isOk()).andExpect(view().name("authors/list"));
        mockMvc.perform(get("/health"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value("UP"));
        mockMvc.perform(get("/api/search").param("q", "Dune"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.books[0].title").value("Dune"));
        mockMvc.perform(get("/api/books/1/preview"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.previewGuide").isNotEmpty());
        mockMvc.perform(get("/api/books")).andExpect(status().isOk());
        mockMvc.perform(get("/api/stats")).andExpect(status().isOk());
        mockMvc.perform(get("/api/books/export.csv"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("ISBN")));
    }

    @Test
    @DisplayName("Unauthenticated /admin redirects to /admin/login")
    void testAdminRequiresAuth() throws Exception {
        mockMvc.perform(get("/admin"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/admin/login?required=true"));
    }

    @Test
    @DisplayName("Demo admin login grants access to all Admin Console routes including Holds Queue")
    void testAdminDemoLoginAccess() throws Exception {
        MockHttpSession session = (MockHttpSession) mockMvc.perform(post("/admin/demo-login"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/admin"))
                .andReturn().getRequest().getSession();

        mockMvc.perform(get("/admin").session(session))
                .andExpect(status().isOk())
                .andExpect(view().name("admin/dashboard"));

        mockMvc.perform(get("/admin/books").session(session))
                .andExpect(status().isOk())
                .andExpect(view().name("admin/books"));

        mockMvc.perform(get("/admin/loans").session(session))
                .andExpect(status().isOk())
                .andExpect(view().name("admin/loans"));

        mockMvc.perform(get("/admin/holds").session(session))
                .andExpect(status().isOk())
                .andExpect(view().name("admin/holds"));

        mockMvc.perform(get("/admin/members").session(session))
                .andExpect(status().isOk())
                .andExpect(view().name("admin/members"));

        mockMvc.perform(get("/admin/audit").session(session))
                .andExpect(status().isOk())
                .andExpect(view().name("admin/audit"));
    }

    @Test
    @DisplayName("Member cannot access /admin routes (RBAC enforcement)")
    void testMemberBlockedFromAdmin() throws Exception {
        MockHttpSession session = (MockHttpSession) mockMvc.perform(post("/demo-login"))
                .andExpect(status().is3xxRedirection())
                .andReturn().getRequest().getSession();

        mockMvc.perform(get("/my-library").session(session))
                .andExpect(status().isOk())
                .andExpect(view().name("member/dashboard"));

        mockMvc.perform(get("/admin").session(session))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/admin/login?required=true"));
    }
}
