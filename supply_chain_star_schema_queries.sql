

CREATE TABLE Dim_Customer
(
    Customer_Key INT AUTO_INCREMENT PRIMARY KEY,
    Customer_ID INT NOT NULL,
    Customer_Segment VARCHAR(50)
);
INSERT INTO Dim_Customer
(
Customer_ID,
Customer_Segment
)
SELECT DISTINCT
customer_id,
customer_segment
FROM supply_chain;



CREATE TABLE Dim_Product
(
    Product_Key INT AUTO_INCREMENT PRIMARY KEY,
    Product_Category_ID INT,
    Category_Name VARCHAR(100),
    Product_Name VARCHAR(255),
    Product_Price DECIMAL(10,2)
);

INSERT INTO Dim_Product
(
    Product_Category_ID,
    Category_Name,
    Product_Name,
    Product_Price
)
SELECT DISTINCT
    product_category_id,
    category_name,
    product_name,
    CAST(product_price AS DECIMAL(10,2))
FROM supply_chain;

CREATE TABLE Dim_Department
(
    Department_Key INT AUTO_INCREMENT PRIMARY KEY,

    Department_ID INT,
    Department_Name VARCHAR(100)
);
INSERT INTO Dim_Department
(
Department_ID,
Department_Name
)

SELECT DISTINCT

department_id,
department_name

FROM supply_chain;

CREATE TABLE Dim_Shipping
(
    Shipping_Key INT AUTO_INCREMENT PRIMARY KEY,

    Shipping_Mode VARCHAR(50),
    Delivery_Status VARCHAR(50),
    Order_Status VARCHAR(50),
    payment_type VARCHAR(50)
);

INSERT INTO Dim_Shipping
(
Shipping_Mode,
Delivery_Status,
Order_Status,
payment_Type
)

SELECT DISTINCT

shipping_mode,
delivery_status,
order_status,
payment_Type

FROM supply_chain;


select * from Dim_Shipping;

CREATE TABLE Dim_Location
(
    Location_Key INT AUTO_INCREMENT PRIMARY KEY,

    Order_City VARCHAR(100),
    Order_Country VARCHAR(100),
    Order_Region VARCHAR(100)
);

INSERT INTO Dim_Location
(
Order_City,
Order_Country,
Order_Region
)

SELECT DISTINCT

order_city,
order_country,
order_region

FROM supply_chain;




CREATE TABLE Fact_Sales
(
    Fact_Key INT AUTO_INCREMENT PRIMARY KEY,

    Order_ID INT,

    Customer_Key INT,
    Product_Key INT,
    Department_Key INT,
    Shipping_Key INT,
    Location_Key INT,

    Order_Date DATETIME,
    Shipping_Date DATETIME,

    Sales DECIMAL(12,2),
    Sales_Per_Customer DECIMAL(12,2),
    Order_Profit DECIMAL(12,2),

    Days_For_Shipping_Real INT,
    Days_For_Shipment_Scheduled INT,
    Order_Processing_Time INT,

    Delay INT,

    Late_Delivery_Risk INT,
    Is_Delayed VARCHAR(10),

    FOREIGN KEY (Customer_Key)
        REFERENCES Dim_Customer(Customer_Key),

    FOREIGN KEY (Product_Key)
        REFERENCES Dim_Product(Product_Key),

    FOREIGN KEY (Department_Key)
        REFERENCES Dim_Department(Department_Key),

    FOREIGN KEY (Shipping_Key)
        REFERENCES Dim_Shipping(Shipping_Key),

    FOREIGN KEY (Location_Key)
        REFERENCES Dim_Location(Location_Key)
);



INSERT INTO Fact_Sales
(
    Order_ID,
    Customer_Key,
    Product_Key,
    Department_Key,
    Shipping_Key,
    Location_Key,

    Order_Date,
    Shipping_Date,

    Sales,
    Sales_Per_Customer,
    Order_Profit,

    Days_For_Shipping_Real,
    Days_For_Shipment_Scheduled,
    Order_Processing_Time,

    Delay,

    Late_Delivery_Risk,
    Is_Delayed
)

SELECT

    s.order_id,

    c.Customer_Key,

    p.Product_Key,

    d.Department_Key,

    sh.Shipping_Key,

    l.Location_Key,

    s.order_date_dateorders,

    s.shipping_date_dateorders,

    CAST(s.sales AS DECIMAL(12,2)),

    CAST(s.sales_per_customer AS DECIMAL(12,2)),

    CAST(s.order_profit_per_order AS DECIMAL(12,2)),

    s.days_for_shipping_real,

    s.days_for_shipment_scheduled,

    s.order_processing_time,

    s.delay,

    s.late_delivery_risk,

    s.is_delayed

FROM supply_chain s

JOIN Dim_Customer c
ON s.customer_id = c.Customer_ID
AND s.customer_segment = c.Customer_Segment

JOIN Dim_Product p
ON s.product_category_id = p.Product_Category_ID
AND s.product_name = p.Product_Name

JOIN Dim_Department d
ON s.department_id = d.Department_ID

JOIN Dim_Shipping sh
ON s.shipping_mode = sh.Shipping_Mode
AND s.delivery_status = sh.Delivery_Status
AND s.order_status = sh.Order_Status
AND s.payment_type = sh.payment_type

JOIN Dim_Location l
ON s.order_city = l.Order_City
AND s.order_country = l.Order_Country
AND s.order_region = l.Order_Region;



SELECT * FROM Fact_Sales;
