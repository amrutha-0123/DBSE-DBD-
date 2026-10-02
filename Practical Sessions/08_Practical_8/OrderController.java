package com.bookflow.controller;
import com.bookflow.model.*;
import com.bookflow.repository.InventoryRepository;
import com.bookflow.service.OrderService;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Min;
import org.springframework.web.bind.annotation.*;

@RestController
public class OrderController {
 private final OrderService service;
 private final InventoryRepository inventory;
 public OrderController(OrderService s,InventoryRepository i){service=s;inventory=i;}

 public record BorrowRequest(@Min(1) Long userId,@Min(1) Long bookId){}

 @PostMapping("/orders")
 public BookOrder borrow(@Valid @RequestBody BorrowRequest r){
  return service.borrow(r.userId(),r.bookId());
 }

 @GetMapping("/inventory/{bookId}")
 public Inventory getInventory(@PathVariable Long bookId){
  return inventory.findById(bookId).orElseThrow();
 }
}
