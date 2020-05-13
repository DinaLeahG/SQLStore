USE [POS_DataBaseFinalProject8]
GO
-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CancelSalesOrder]
@SalesOrderId int,
@CustomerID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	begin try
		begin transaction

		--Lets make sure the order we are removing EXISTS!!!
		if not exists(select SalesOrderId from SalesOrder where SalesOrderId =@SalesOrderId)
		throw 6000,'Invalid Sales Order Number',1;

		--Now if it has indeed existed we have to update Items table
		merge Item as targettable
		using SalesOrderDetail as source
		on targettable.upc = source.upc
		and source.SalesOrderId =@SalesOrderID

		when matched
		then update set targettable.QtyInventory =targettable.QtyInventory +source.QtySold;

		--remove the details about this order

		delete from SalesOrderDetail
		where SalesOrderId=@SalesOrderId

		--Remove the actual order

		delete from SalesOrder
		where SalesOrderID=@SalesOrderId and customerID=@CustomerID

		commit transaction
		end try
		begin catch
			rollback;
			throw;
			end catch
		
END

