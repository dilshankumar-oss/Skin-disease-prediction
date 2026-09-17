package com.skindisease.tag;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import jakarta.servlet.jsp.JspException;
import jakarta.servlet.jsp.JspWriter;
import jakarta.servlet.jsp.tagext.SimpleTagSupport;

/**
 * Custom JSP Tag Handler that outputs the current server date and time (Assignment Q11, Q14).
 */
public class CustomDateTag extends SimpleTagSupport {

    private String format = "EEEE, MMMM d, yyyy - hh:mm:ss a";

    // Allow users to pass a custom date format as an attribute
    public void setFormat(String format) {
        if (format != null && !format.trim().isEmpty()) {
            this.format = format;
        }
    }

    @Override
    public void doTag() throws JspException, IOException {
        JspWriter out = getJspContext().getOut();
        try {
            SimpleDateFormat sdf = new SimpleDateFormat(format);
            String formattedDate = sdf.format(new Date());
            out.print(formattedDate);
        } catch (IllegalArgumentException e) {
            out.print("Invalid date format: " + format);
        }
    }
}
