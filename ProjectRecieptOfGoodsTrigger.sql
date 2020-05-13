-- ================================================
-- Template generated from Template Explorer using:
-- Create Trigger (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- See additional Create Trigger templates for more
-- examples of different Trigger statements.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
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
CREATE TRIGGER [dbo].[UpdatesQtyInItems]
on[dbo].[ReceiptOfGoods]
After Insert,Update
--This trigger will take in the qty recieved and update the items table accordingly.
As
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	declare @QauntityRecieved int
	declare @UPC int

	if exists (select *  from inserted)
	begin
	select @QauntityRecieved = QauntityRecieved from inserted
	select @UPC = UPC from inserted

	--Now we have that information we can update our tables!
	update Item
	set QtyInventory=QtyInventory+@QauntityRecieved
	where UPC=@UPC

	end

END
GO
