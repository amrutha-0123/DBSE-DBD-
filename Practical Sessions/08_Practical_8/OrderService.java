package com.bookflow.service;
import com.bookflow.model.*;
import com.bookflow.repository.*;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

@Service
public class OrderService {
 private final InventoryRepository inventory;
 private final OrderRepository orders;
 public OrderService(InventoryRepository i,OrderRepository o){inventory=i;orders=o;}

 @Transactional
 public BookOrder borrow(Long userId,Long bookId){
  Inventory item=inventory.findById(bookId)
   .orElseThrow(()->new OutOfStockException("Book not found"));
  if(item.getAvailableStock()<=0)
   throw new OutOfStockException("Book is out of stock");
  item.setAvailableStock(item.getAvailableStock()-1);
  inventory.save(item);
  BookOrder order=new BookOrder();
  order.setUserId(userId);
  order.setBookId(bookId);
  order.setStatus("BORROWED");
  return orders.save(order);
 }
}
