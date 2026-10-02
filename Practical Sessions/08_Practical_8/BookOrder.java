package com.bookflow.model;
import jakarta.persistence.*;

@Entity
@Table(name="orders")
public class BookOrder {
 @Id @GeneratedValue(strategy=GenerationType.IDENTITY) private Long id;
 private Long userId;
 private Long bookId;
 private String status;
 public Long getId(){return id;}
 public Long getUserId(){return userId;}
 public void setUserId(Long v){userId=v;}
 public Long getBookId(){return bookId;}
 public void setBookId(Long v){bookId=v;}
 public String getStatus(){return status;}
 public void setStatus(String v){status=v;}
}
