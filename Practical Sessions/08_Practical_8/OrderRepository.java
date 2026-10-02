package com.bookflow.repository;
import com.bookflow.model.BookOrder;
import org.springframework.data.jpa.repository.JpaRepository;
public interface OrderRepository extends JpaRepository<BookOrder,Long>{}
