USE [POS_DataBaseFinalProject8]
GO
/****** Object:  Trigger [dbo].[SalesOrderDetailTrigger]    Script Date: 1/22/2020 6:30:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create TRIGGER [dbo].[SalesOrderDetailTrigger]
on[dbo].[SalesOrderDetail]
after update,insert,delete
as BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare	@transType char(1)
	declare @UPC int
	declare @SalesOrderID int
	declare @subtotal decimal
	declare @QtyOrdered int

	if exists (select * from inserted)
	begin
	if exists (select * from deleted)
	begin
		set @transType ='I'
		end
	else 
	begin
	set @transType ='U'
	end
	end

	else 
	begin
	set @transType ='D'
	end

	if(@transType='I' or @transType='U')
	begin
	select @UPC = upc from inserted
	select @SalesOrderID = SalesOrderID from inserted
	select @subtotal= subtotal from inserted
	select @QtyOrdered = QtySold from inserted
	update SalesOrder
	set TotalSale =TotalSale+@subtotal
	where SalesOrderID=@SalesOrderID

	--Now we lower the qauntity in stock for items
	update Item
	set QtyInventory =QtyInventory- @QtyOrdered
	where UPC=@UPC
	end

	if(@transType='D' or @transType='U')
	begin
	--delete
	select @UPC = upc from deleted
	select @SalesOrderID = SalesOrderID from deleted
	select @subtotal= subtotal from deleted
	select @QtyOrdered = QtySold from deleted
	update SalesOrder
	set TotalSale =TotalSale-@subtotal
	where SalesOrderID=@SalesOrderID

	--Now we update the qauntity in stock for items
	update Item
	set QtyInventory =QtyInventory+ @QtyOrdered
	where UPC=@UPC
	end


END

