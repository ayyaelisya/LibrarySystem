package com.book.model;


public class Book {
    private int id;
    private String title;
    private String author;
    private double price;
    private String status;

    public Book() {}

    public Book(int id, String title, String author, double price, String status) {
        this.id = id;
        this.title = title;
        this.author = author;
        this.price = price;
        this.status = status;
    }

    public Book(String title, String author, double price) {
        this.title = title;
        this.author = author;
        this.price = price;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}