const express=require("express");
const mongoose=require("mongoose");
const {User,Activity}=require("./db");
const router=express.Router();

router.post("/users",async(req,res)=>{
 try{res.status(201).json(await User.create(req.body))}
 catch(e){res.status(400).json({error:e.message})}
});

router.get("/users/:id",async(req,res)=>{
 if(!mongoose.isValidObjectId(req.params.id))
  return res.status(400).json({error:"Invalid user ID"});
 const user=await User.findById(req.params.id);
 if(!user)return res.status(404).json({error:"User not found"});
 res.json(user);
});

router.post("/activities",async(req,res)=>{
 try{res.status(201).json(await Activity.create(req.body))}
 catch(e){res.status(400).json({error:e.message})}
});

router.get("/activities/:user_id",async(req,res)=>{
 if(!mongoose.isValidObjectId(req.params.user_id))
  return res.status(400).json({error:"Invalid user ID"});
 res.json(await Activity.find({user_id:req.params.user_id}));
});

module.exports=router;
