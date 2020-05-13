--CHANA LAVIAN & DINA LEAH GARBER 
--Final Project Part B
--Final Project

use master 
go 
create database POS_DataBaseFinalProject8
go 
use  POS_DataBaseFinalProject8
go 
create table ProductCategory(
	CategoryID int not null,
	CategoryDescription varchar(45) not null,
	IsTaxable varchar(1) not null,
	IsFood varchar(1) not null,

	constraint [PK_ProductCategory] primary key (CategoryID),
	constraint [CHK_CategoryDescription] check (upper(CategoryDescription) in ('ALUMINUM', 'BAKERY','CANDY','CHICKEN','FISH','FRUIT', 'GROCERY','MAGAZINE','MEAT','PAPERGOODS')),
	CONSTRAINT [CHK_Taxable] check (upper(IsTaxable) in ('Y','N')),
	constraint [CHK_IsFood] check (upper(IsFood) in ('Y','N'))
);
create table VENDOR (
	VendorID int identity(1,1) not null,
	VendorName varchar(45) not null,
	VendorPhoneNumber varchar(10) not null,
	
	constraint [PK_VENDOR] primary key (VendorID)
);
create table ITEM(
	UPC int not null,
	ItemName varchar(45) not null,
	UnitPrice Decimal(8,2) not null,
	CategoryID int not null,
	QtyInventory int not null,
	reorderLevel int not null,
	vendorID int not null

	constraint [PK_ITEM] primary key (UPC),
	constraint [CHK_UPCPrice] check (UnitPrice > 0.00),
	constraint [FK_ITEM_PRODUCTCATEGORY] foreign key (CategoryID) 
		references productcategory(categoryID), 
		constraint [FK_ITEM_VEndorID] foreign key(VendorID)
		references Vendor(VendorID)
);

create table DiscountedItem(
	UPC int not null,
	startDate date not null,
	endDate date not null,
	qtyLimit int null,
	discountedPrice Decimal not null,
	minPurchaseNonSaleItems decimal(6,2) null

	constraint [PK_DiscountedItem] primary key (UPC,startDate),
	constraint [CHK_discountedPrice] check (discountedPrice > 0.00),
	constraint [FK_DiscountItem_Item] foreign key (upc)
		references item (UPC) 
);
create table EmpTypes(
	EmpTypeID int not null,
	EmpTypeDescription varchar(45) not null

	constraint [PK_EmpTypes] primary key (EmpTypeID),
	constraint[UIX_EMPTypes] unique(EmpTypeDescription)
);

create table EMPLOYEE(
	employeeID int not null,
	EmpTypeID int not null,
	Emp_Fname varchar(45) not null,
	Emp_LName varchar(45) not null,
	SSN int not null,
	Emp_Birthdate date not null,
	Street varchar(35) not null,
	City varchar(45) not null,
	EmpState varchar(2)  not null,
	Zip int not null

	constraint [PK_EMPLOYEE] primary key (employeeID),
	constraint [UQ_SSN] unique (SSN),
	constraint [FK_EMPOYEE_EMPTYPE] foreign key (EmpTypeID)
		references emptypes (empTypeID)
);

create table Cashier(
	CashierID int not null,
	HireDate date not null,
	EmployeeID int not null

	constraint [PK_Cashier] primary key (CashierID),
	constraint [FK_Cashier_Employee] foreign key (employeeID)
		references employee (employeeID)
);

create table CreditCard (
	CreditCardID int not null,
	CreditCardNumber int not null,
	ExpirationDate date not null,
	SecurityCode varchar(3) not null,
	Zip int not null

	constraint [PK_CreditCard] primary key (CreditCardID),
	constraint [CHK_ExpirationDate] check (ExpirationDate >= getdate())
	
);



create table EBT (
	EBTID int not null,
	EBTCardNumber int not null,
	EBTBalance decimal (8,2) not null,
	
	constraint [PK_EBT] primary key (EBTID)
);

create table Customer(
	CustomerID int identity(1,1) not null,
	Cust_Fname varchar(30) not null,
	Cust_Lname varchar(30) not null,
	Cust_Phonenumber int not null,
	CreditCardID int not null,
	Cust_Street varchar (45) not null,
	Cust_City varchar(45) not null,
	Cust_State varchar(2) not null,
	Cust_Zip int not null,
	EBTID int null

	constraint [PK_Customer] primary key (customerID),
	constraint[FK_CreditCardID] foreign key(CreditCardID) references
	CreditCard(CreditCardID),
	constraint[FK_EBTCardID] foreign key(EBTID)
	references EBT(EBTID)
);

create table Cashier_Customer (
	CustomerID int not null,
	CashierID int not null

	constraint [PK_Cashier_Customer] primary key (CashierID, CustomerID)
	constraint [FK_Customer] foreign key (customerID)
		references customer (customerID),
	constraint [FK_Cashier] foreign key (cashierID)
		references cashier (cashierID) 
);


create table SalesOrder (
	SalesOrderID int not null,
	dateOfSale date not null,
	customerID int null,
	cashierID int not null,
	TotalSale decimal not null
	

	constraint [PK_SalesOrder] primary key (SalesOrderID),
	constraint [FK_Customer_salesOrder] foreign key (customerID)
		references customer (customerID),
	constraint [FK_Cashier_salesOrder] foreign key (cashierID)
		references cashier (cashierID) 
);

create table SalesOrderDetail (
	SalesOrderDetailID int not null,
	UPC int not null,
	QtySold int not null,
	UnitPrice decimal (6,2) not null,
	OnSale varchar(1) not null,
	SalesOrderID int not null,
	Subtotal as(UnitPrice * QtySold) Persisted

	constraint [PK_SalesOrderDetail] primary key (SalesOrderDetailID),
	constraint [CHK_UnitPrice] check (UnitPrice > 0.00),
	constraint [CHK_OnSale] check (upper(OnSale) in ('Y','N')),
	constraint [FK_SalesOrder] foreign key (SalesOrderID)
		references SalesOrder (SalesOrderID) ,
		constraint[FK_SalesOrderDetail_UPC] foreign key (UPC)
		references Item(UPC)
);
create table PaymentDetails (
	PaymentDetailsID int not null,
	PaymentDetails varchar(45) not null

	constraint [PK_PaymentDetails] primary key (PaymentDetailsID),
	constraint[CHK_PaymentDetails] check(upper(PaymentDetails) in('Credit','EBT', 'CASH','Debit','CHECK'))
);

create table PAYMENT (
	PaymentID int not null,
	PaymentDetailsID int not null,
	SalesOrderID int not null

	constraint [PK_Payment] primary key (PaymentID),
	constraint[FK_Payment] foreign key(SalesOrderID)
	references SalesOrder(SalesOrderID),
	constraint[FK_PaymentDetailsID] foreign key(PaymentDetailsID)
	references PaymentDetails(PaymentDetailsID)
);



create table Receipt (
	ReceiptID int not null,
	CustomerID int null,
	RegisterNumber int not null,
	CashierID int not null,
	ReceiptDate as(getDate()),
	SalesTax decimal(8,2) null,
	Total Decimal(8,2) not null,
	SalesOrderID int not null
	constraint [PK_Receipt] primary key (ReceiptID),
	constraint [FK_Receipt] foreign key (SalesOrderID)
	references  SalesOrder(SalesOrderID),
	constraint[FK_CustomerID] foreign key(CustomerID)
	references Customer(CustomerID),
	constraint[FK_CasheirID] foreign key(CashierID)
	references Cashier(CashierID)
);



create table PurchaseOrder (
	PurchaseOrderID int not null,
	PurchaseOrderDate date not null,
	VendorID int not null,
	TotalDue decimal not null
	

	constraint [PK_PurchaseOrder] primary key (PurchaseOrderID),
	constraint[FK_PurchaseVendor] foreign key(VendorID)
	references Vendor(VendorID)
);

create table ReceiptOfGoods(
	ReceiptOfGoodsID int not null,
	UPC int not null,
	PurchaseOrderID int  not null,
	QuantityOrdered int not null,
	QauntityRecieved int null

	constraint [PK_ReceiptOfGoods] primary key (ReceiptOfGoodsID),
	constraint[FK_ReceiptOfGoods_PurchaseOrderID] foreign key(PurchaseOrderID)
	references PurchaseOrder(PurchaseOrderID)
);

create table LineItems (
	LineItemsID int not null,
	UPC int not null,
	QuantityOrdered int not null,
	UnitCost decimal (6,2) null,
	Subtotal  As(QuantityOrdered*UnitCost)Persisted,
	PurchaseOrderID int not null,
	QauntityRecieved int null

	constraint [PK_LineItems] primary key (LineItemsID),
	constraint [CHK_UnitCostAndSubtotal] check (UnitCost > 0.00 and subtotal >0.00),
	constraint[FK_PurchaseOrderID] foreign key(PurchaseOrderID) 
	references PurchaseOrder(PurchaseOrderID)
);
create table PayVendor (
	PayVendorID int not null,
	PurchaseOrderID int not null,
	PaymentDetailID int not null

	constraint [PK_PayVendorID] primary key (PayVendorID),
	constraint[FK_Pay_Vendor_PurchaseOrderID] foreign key (PurchaseOrderID)
	references PurchaseOrder(PurchaseOrderID),
	constraint[FK_PaymentDetailID] foreign key(PaymentDetailID)
	references PaymentDetails(PaymentDetailsID) );

	create table customerReturn(
	customerReturnID int identity(1,1),
	recieptID int not null,
	CustomerID int null,
	SalesOrderID int not null,
	UPC int not null,
	qtyReturning int not null,
	refundedAmount decimal(8,2) null

	constraint[Pk_customerReturnID] primary key (customerReturnID),
	constraint[FK_SalesOrderID_Return] foreign key (SalesOrderID)
	references SalesOrder(SalesOrderID),
	constraint [FK_UPC_Return] foreign key (UPC) references
	Item(UPC),
	constraint [FK_CustomerID_Return] foreign key (CustomerID) references
	Customer(CustomerID),
	constraint [FK_return_RecieptID] foreign key (recieptID)
	references receipt(receiptID)

);