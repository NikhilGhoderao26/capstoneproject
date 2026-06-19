
const express=require("express")
const mysql=require("mysql2")
const cors=require("cors")

const app=express()
app.use(express.json())
app.use(cors())

const dbConfig = {
 host: process.env.MYSQL_HOST || "mysql",
 user: process.env.MYSQL_USER || "root",
 password: process.env.MYSQL_PASSWORD || "password",
 database: process.env.MYSQL_DATABASE || "ecommerce"
}

let db;
function connectWithRetry() {
 db = mysql.createConnection(dbConfig);
 db.connect((err) => {
   if (err) {
     console.error('MySQL connection failed, retrying in 3s...', err.message);
     setTimeout(connectWithRetry, 3000);
   } else {
     console.log('Connected to MySQL');
   }
 });
 db.on('error', (err) => {
   console.error('MySQL error', err.message);
   if (err.code === 'PROTOCOL_CONNECTION_LOST') {
     connectWithRetry();
   }
 });
}
connectWithRetry();

app.get("/health", (req, res) => res.json({ status: 'ok' }))

app.get("/inventory",(req,res)=>{
 db.query("SELECT * FROM inventory",(err,result)=>{
   if(err) throw err
   res.json(result)
 })
})

app.put("/inventory/:productId",(req,res)=>{
 const {stock}=req.body
 const productId=req.params.productId

 db.query("UPDATE inventory SET stock=? WHERE product_id=?",
 [stock,productId],(err)=>{
   if(err) throw err
   res.json({message:"stock updated"})
 })
})

app.listen(5002,()=>console.log("inventory service running"))

