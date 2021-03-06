USE [POS_DataBaseFinalProject8]
GO
/****** Object:  Trigger [dbo].[UpdateTotalDue]    Script Date: 1/14/2020 12:30:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create TRIGGER [dbo].[UpdateTotalDue]
on [dbo].[LineItems]
after insert,update,delete
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	declare @transType char(1)
	declare @PurchaseOrderId int
	declare @subtotal decimal
	declare @UPC int
	declare @qtyOrdered int
	declare @qtyRecieved int
	
	if exists (select * from inserted)
	begin


	if exists(select * from deleted)
	begin
			       set @transType = 'U'
		end
            else
			   begin
			        set @transType = 'I'
			   end
		end
	else
	begin
		set @transType='D'
		end
	if(@transType='I'or @transType='U') --Inserting into itemLine
	begin
		select @PurchaseOrderId = PurchaseOrderID from inserted
		select @subtotal = subtotal from inserted
		select @UPC = upc from inserted
		select @qtyOrdered = QuantityOrdered from inserted

		update Item
	set QtyInventory =QtyInventory-@qtyOrdered
	where UPC=@UPC

		--change the total due
		update PurchaseOrder
		set TotalDue = totaldue+@subtotal
		where PurchaseOrderID=@PurchaseOrderId
	end

	if(@transType='D' or @transType='U')
	begin
	 --Get the subtotal of the record being deleted
	select @subtotal = subtotal from deleted
	select @PurchaseOrderId = @PurchaseOrderId from deleted
	select @QtyRecieved = qauntityRecieved from deleted
	select @UPC = upc from inserted
	update Item
	set QtyInventory =QtyInventory+@qtyRecieved
	where UPC=@UPC

	update PurchaseOrder
	set TotalDue = totaldue-@subtotal	
	where PurchaseOrderID=@PurchaseOrderId
	end
		
	end

	







    
