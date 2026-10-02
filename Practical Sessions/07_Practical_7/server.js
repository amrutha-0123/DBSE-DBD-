const express=require("express");
const {connectDB}=require("./db");
const routes=require("./routes");

const app=express();
app.use(express.json());
app.use(routes);

connectDB().then(()=>app.listen(5001,()=>{
 console.log("User service running on port 5001");
})).catch(e=>console.error("MongoDB connection failed:",e.message));
