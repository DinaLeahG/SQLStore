--Populating the Tables
use POS_DataBaseFinalProject8
go

insert into ProductCategory(CategoryID,CategoryDescription,IsTaxable,IsFood)
values(128,'CANDY','Y','Y'),(139,'ALUMINUM','Y','N'),(144,'BAKERY','Y','Y'),(155,'PAPERGOODS','N','N'),
(132,'MEAT','Y','Y'),(122,'FRUIT','N','Y')


insert into Vendor(VendorName,VendorPhoneNumber)
values('Sams Deli','9178885454'),('Dylans Candy Bar','7679987656'),('Costco','8485654343'),('Amazing Savings','7186454321')

insert into Item(UPC,ItemName,UnitPrice,CategoryID,QtyInventory,reorderLevel,vendorID)
values(123456,'Paskez Lollypops',4.50,128,10,20,2),
(71234,'Entennmanns Chocolate Donuts',2.50,144,50,0,2),(33037,'Dixie Silver Plates',14.99,144,40,20,4),
(50110,'Watermelon',10.99,122,35,10,3),(3933,'Strawberrys',5.99,122,60,0,3)

insert into DiscountedItem(UPC,startDate,endDate,qtyLimit,discountedPrice,minPurchaseNonSaleItems)
values(71234,'2020-09-10','2021-01-01',150,1.99,5),(33037,'2020-05-04','2020-06-09',40,10.99,10)

insert into EmpTypes(empTypeID,EmpTypeDescription)
values(5,'Truck Unloader'),(4,'Re-Stock Shelfs'),(3,'Cleaner'),(2,'Manager'),(1,'Cashier')

insert into EMPLOYEE(employeeID,EmpTypeID,Emp_Fname,Emp_LName,SSN,Emp_Birthdate,Street,City,EmpState,zip)
values(5405,1,'David','Stanton',119087456,'1994-09-08','Kings Highway','Brooklyn','NY','11415'),
(5415,4,'Brian','Sterm',116776565,'1990-09-07','Metropolitan','Queens','NY',11365),
(5424,3,'Veronica','Smith',114332524,'1987-10-12','E Redfield Rd','Scottsdale','Az',11815),
(5666,2,'Morgan','Maple',115669845,'1975-08-11','Main St','Los Angelos','CA',11954)



insert into Cashier(CashierID,HireDate,EmployeeID)
values(1001,'2019-10-10',5405)

insert into CreditCard(CreditCardID,CreditCardNumber,ExpirationDate,SecurityCode,Zip)
values(110,545667924,'2023-08-11',333,11514),(111,66733924,'2024-09-12',921,11432)

insert into EBT(EBTID,EBTCardNumber,EBTBalance)
values(220,2029877645,500.00),(221,234567765,750.00),(222,789104325,1000)

insert into Customer(Cust_Fname,Cust_Lname,Cust_Phonenumber,CreditCardID,Cust_Street,Cust_City,
Cust_State,Cust_Zip,EBTID)
values('Sarah','Harris',71864452,110,'154 east Broadway st','Manhattan','NY','11212',220),
('Larry','Gordon',12435563,111,'Sesame st','Los Angelos','CA','11815',221)

insert into Cashier_Customer(CustomerID,CashierID)
values(1,1001),(2,1001)

insert into SalesOrder(SalesOrderID,dateOfSale,customerID,cashierID,TotalSale)
values(600,'2020-9-6',1,1001,9.00),(601,'2019-08-07',2,1001,500)

insert into SalesOrderDetail(SalesOrderDetailID,UPC,QtySold,UnitPrice,OnSale,SalesOrderID)
values(7701,123456,4.50,2,'N',600),(7702,3933,5.99,83,'N',601)

insert into PaymentDetails(PaymentDetailsID,PaymentDetails)
values(9900,'Credit'),(9901,'EBT'),(9902,'Cash'),(9903,'Debit'),(9904,'CHECK')

insert into Payment(PaymentID,PaymentDetailsID,SalesOrderID)
values(4401,9900,600),(4402,9901,601)

insert into Receipt(ReceiptID,CustomerID,RegisterNumber,CashierID,SalesTax,Total,SalesOrderID)
values(001001,1,1,1001,2.50,9.00,600)

insert into PurchaseOrder(PurchaseOrderID,PurchaseOrderDate,VendorID,TotalDue)
values(2100,'2020-07-9',2,500.00),(2101,'2020-01-01',3,959.75)

insert into ReceiptOfGoods(ReceiptOfGoodsID,UPC,PurchaseOrderID,QuantityOrdered,QauntityRecieved)
values(33301,71234,2100,500,500),(33302,50110,2101,700,699)


insert into LineItems(LineItemsID,UPC,QuantityOrdered,UnitCost,PurchaseOrderID)
values(777771,71234,500,1.50,2100),(777772,50110,25,5.99,2101),(777773,71234,300,1.50,2101)

insert into PayVendor(PayVendorID,PurchaseOrderID,PaymentDetailID)
values(0000001,2100,9900),(0000002,2101,9901)

insert into customerReturn(recieptID,CustomerID,SalesOrderID,UPC,qtyReturning)
values(001001,1,600,123456,2)