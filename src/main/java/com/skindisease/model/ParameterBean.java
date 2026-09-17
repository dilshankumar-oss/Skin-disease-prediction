package com.skindisease.model;

import java.io.Serializable;

/**
 * JavaBean representing client input parameter properties (Assignment Q10).
 */
public class ParameterBean implements Serializable {
    private static final long serialVersionUID = 1L;

    private String clientName;
    private String clientSystem;
    private String clientFeedback;
    private int rating;

    public ParameterBean() {
        // Default constructor
    }

    public String getClientName() {
        return clientName;
    }

    public void setClientName(String clientName) {
        this.clientName = clientName;
    }

    public String getClientSystem() {
        return clientSystem;
    }

    public void setClientSystem(String clientSystem) {
        this.clientSystem = clientSystem;
    }

    public String getClientFeedback() {
        return clientFeedback;
    }

    public void setClientFeedback(String clientFeedback) {
        this.clientFeedback = clientFeedback;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    @Override
    public String toString() {
        return "ParameterBean [clientName=" + clientName + ", clientSystem=" + clientSystem + ", clientFeedback="
                + clientFeedback + ", rating=" + rating + "]";
    }
}
