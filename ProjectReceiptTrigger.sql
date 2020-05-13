USE [POS_DataBaseFinalProject8]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[ReceiptTotalTrigger]
   ON  Receipt
   AFTER insert
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	declare @SalesOrderID int
	declare @sum decimal(8,2)
	declare @salestax decimal(8,2)
	declare @receiptID int

	select @receiptID = receiptID from inserted
	select @SalesOrderID = SalesOrderID from inserted
	select @salestax = salestax from inserted

	--Now we are going to the SalesOrder Table and getting the total Sum and using it for our Reciept Table
	select @sum = totalsale from SalesOrder
	where SalesOrderID=@SalesOrderID

	--Now we add in the sales tax to our sum and that is the order total
	update Receipt
	set Total = @sum+@salestax
	where ReceiptID = @receiptID





END
GO
