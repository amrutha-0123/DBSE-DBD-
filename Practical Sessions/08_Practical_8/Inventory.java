package com.bookflow.model;
import jakarta.persistence.*;
import jakarta.validation.constraints.Min;

@Entity
@Table(name="inventory")
public class Inventory {
 @Id @Column(name="book_id") private Long bookId;
 @Min(0) private int totalStock;
 @Min(0) private int availableStock;
 public Long getBookId(){return bookId;}
 public void setBookId(Long v){bookId=v;}
 public int getTotalStock(){return totalStock;}
 public void setTotalStock(int v){totalStock=v;}
 public int getAvailableStock(){return availableStock;}
 public void setAvailableStock(int v){availableStock=v;}
}
