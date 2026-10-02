package com.bookflow.controller;
import com.bookflow.service.OutOfStockException;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

@RestControllerAdvice
public class GlobalExceptionHandler {
 @ExceptionHandler(OutOfStockException.class)
 @ResponseStatus(HttpStatus.CONFLICT)
 public Map<String,String> handle(OutOfStockException e){
  return Map.of("error","OUT_OF_STOCK","message",e.getMessage());
 }
}
