<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ attribute name="title" required="true" rtexprvalue="true" type="java.lang.String" %>
<%@ attribute name="type" required="false" rtexprvalue="true" type="java.lang.String" %>

<%
    // Default alert type is info
    if (type == null || type.trim().isEmpty()) {
        type = "info";
    }
    
    // Choose styling class based on type
    String alertClass = "alert-info";
    String iconPath = "M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"; // Default info icon
    
    if ("success".equalsIgnoreCase(type)) {
        alertClass = "alert-success";
        iconPath = "M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z";
    } else if ("warning".equalsIgnoreCase(type)) {
        alertClass = "alert-warning";
        iconPath = "M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z";
    } else if ("danger".equalsIgnoreCase(type)) {
        alertClass = "alert-danger";
        iconPath = "M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z";
    }
%>

<div class="alert <%= alertClass %>" style="margin-top: 15px; margin-bottom: 15px; display: flex; gap: 15px; align-items: flex-start;">
    <svg width="24" height="24" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" style="flex-shrink: 0; margin-top: 2px;">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="<%= iconPath %>"></path>
    </svg>
    <div>
        <h4 style="margin: 0 0 5px 0; font-size: 1rem; font-weight: 600;"><%= title %></h4>
        <div style="font-size: 0.88rem; opacity: 0.95; line-height: 1.4;">
            <jsp:doBody />
        </div>
    </div>
</div>
