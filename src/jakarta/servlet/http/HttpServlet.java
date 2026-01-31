package jakarta.servlet.http;

import jakarta.servlet.ServletException;
import java.io.IOException;

public abstract class HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    }
}
