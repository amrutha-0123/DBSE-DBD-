package com.bookflow.repository;
import com.bookflow.model.Inventory;
import org.springframework.data.jpa.repository.JpaRepository;
public interface InventoryRepository extends JpaRepository<Inventory,Long>{}
