use bookflow_db;

db.book_metadata.insertMany([
 {book_id:1,title:"The Martian",published_year:2014,format:"Digital eBook",
  technical_specs:{file_size_mb:4.8,file_format:"EPUB"},
  reviews:[{member_id:1,rating:5,comments:"Amazing space survival story."},
           {member_id:2,rating:4,comments:"Very entertaining."}]},
 {book_id:2,title:"Dune",published_year:1965,format:"Digital eBook",
  technical_specs:{file_size_mb:6.1,file_format:"PDF"},
  reviews:[{member_id:1,rating:5,comments:"A classic story about space."},
           {member_id:3,rating:5,comments:"Rich world building."}]},
 {book_id:3,title:"Clean Code",published_year:2008,format:"Printed Book",
  technical_specs:{paper_weight_gsm:80},
  reviews:[{member_id:2,rating:4,comments:"Useful software engineering advice."}]},
 {book_id:4,title:"Project Hail Mary",published_year:2021,format:"Digital eBook",
  technical_specs:{file_size_mb:5.2,file_format:"EPUB"},
  reviews:[{member_id:1,rating:5,comments:"Excellent space adventure."},
           {member_id:3,rating:5,comments:"Great science fiction."}]}
]);

db.book_metadata.find({"reviews.rating":{$gt:4}});
db.book_metadata.find({published_year:{$in:[2014,1965,2021]}});
db.book_metadata.find({format:{$regex:"Digital",$options:"i"}});

db.book_metadata.aggregate([
 {$match:{published_year:{$gt:2020}}},
 {$unwind:"$reviews"},
 {$group:{_id:"$title",average_rating:{$avg:"$reviews.rating"}}}
]);

db.book_metadata.createIndex({"reviews.comments":"text"});
db.book_metadata.find({$text:{$search:"space"}}).explain("executionStats");
