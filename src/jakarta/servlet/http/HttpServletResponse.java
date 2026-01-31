package jakarta.servlet.http;

import java.io.PrintWriter;
import java.io.IOException;

public interface HttpServletResponse {
    void sendRedirect(String location) throws IOException;

    PrintWriter getWriter() throws IOException;

    void setContentType(String type);

    void setHeader(String name, String value);

    void setStatus(int status);
}
