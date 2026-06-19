
const express = require("express")
const mysql = require("mysql2")
const cors = require("cors")

const app = express()
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

app.get("/products",(req,res)=>{
  db.query("SELECT * FROM products",(err,result)=>{
    if(err) throw err
    res.json(result)
  })
})

app.post("/products",(req,res)=>{
  const {name,price,stock}=req.body
  db.query("INSERT INTO products(name,price,stock) VALUES (?,?,?)",
  [name,price,stock],(err)=>{
    if(err) throw err
    res.json({message:"product created"})
  })
})

app.delete("/products/:id",(req,res)=>{
  db.query("DELETE FROM products WHERE id=?",[req.params.id],(err)=>{
    if(err) throw err
    res.json({message:"deleted"})
  })
})

app.listen(5000,()=>console.log("product service running"))

