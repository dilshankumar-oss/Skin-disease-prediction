package com.skindisease.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Model class representing a To-Do list item (Assignment Q7).
 */
public class Todo implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String task;
    private String status;
    private Timestamp createdAt;

    public Todo() {
    }

    public Todo(int id, String task, String status, Timestamp createdAt) {
        this.id = id;
        this.task = task;
        this.status = status;
        this.createdAt = createdAt;
    }

    public Todo(String task, String status) {
        this.task = task;
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTask() {
        return task;
    }

    public void setTask(String task) {
        this.task = task;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Todo [id=" + id + ", task=" + task + ", status=" + status + ", createdAt=" + createdAt + "]";
    }
}
