package com.skindisease.model;

import java.io.Serializable;

/**
 * Model class representing a Patient Skin Disease Analysis Record.
 */
public class AnalysisRecord implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String patientName;
    private int age;
    private String symptomRedness; // "Yes" or "No"
    private String symptomItchy;   // "Yes" or "No"
    private String symptomScaling; // "Yes" or "No"
    private int duration;          // in days
    private String diagnosis;
    private String notes;

    public AnalysisRecord() {
    }

    public AnalysisRecord(int id, String patientName, int age, String symptomRedness, String symptomItchy, 
                          String symptomScaling, int duration, String diagnosis, String notes) {
        this.id = id;
        this.patientName = patientName;
        this.age = age;
        this.symptomRedness = symptomRedness;
        this.symptomItchy = symptomItchy;
        this.symptomScaling = symptomScaling;
        this.duration = duration;
        this.diagnosis = diagnosis;
        this.notes = notes;
    }

    public AnalysisRecord(String patientName, int age, String symptomRedness, String symptomItchy, 
                          String symptomScaling, int duration, String diagnosis, String notes) {
        this.patientName = patientName;
        this.age = age;
        this.symptomRedness = symptomRedness;
        this.symptomItchy = symptomItchy;
        this.symptomScaling = symptomScaling;
        this.duration = duration;
        this.diagnosis = diagnosis;
        this.notes = notes;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getPatientName() {
        return patientName;
    }

    public void setPatientName(String patientName) {
        this.patientName = patientName;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public String getSymptomRedness() {
        return symptomRedness;
    }

    public void setSymptomRedness(String symptomRedness) {
        this.symptomRedness = symptomRedness;
    }

    public String getSymptomItchy() {
        return symptomItchy;
    }

    public void setSymptomItchy(String symptomItchy) {
        this.symptomItchy = symptomItchy;
    }

    public String getSymptomScaling() {
        return symptomScaling;
    }

    public void setSymptomScaling(String symptomScaling) {
        this.symptomScaling = symptomScaling;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public String getDiagnosis() {
        return diagnosis;
    }

    public void setDiagnosis(String diagnosis) {
        this.diagnosis = diagnosis;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    @Override
    public String toString() {
        return "AnalysisRecord [id=" + id + ", patientName=" + patientName + ", age=" + age + 
               ", symptomRedness=" + symptomRedness + ", symptomItchy=" + symptomItchy + 
               ", symptomScaling=" + symptomScaling + ", duration=" + duration + 
               ", diagnosis=" + diagnosis + ", notes=" + notes + "]";
    }
}
