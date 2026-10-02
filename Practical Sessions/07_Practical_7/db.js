const mongoose=require("mongoose");
const MONGO_URI=process.env.MONGO_URI||"mongodb://127.0.0.1:27017/bookflow_users";

const userSchema=new mongoose.Schema({
 username:{type:String,required:true},
 email:{type:String,required:true,unique:true},
 profile:{type:mongoose.Schema.Types.Mixed,default:{}}
});

const activitySchema=new mongoose.Schema({
 user_id:{type:mongoose.Schema.Types.ObjectId,required:true,ref:"User"},
 action:{type:String,required:true},
 timestamp:{type:Date,default:Date.now}
});

const User=mongoose.model("User",userSchema);
const Activity=mongoose.model("Activity",activitySchema);

async function connectDB(){await mongoose.connect(MONGO_URI);}
module.exports={connectDB,User,Activity};
