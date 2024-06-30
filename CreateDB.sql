
alter database hoteldb set single_user with rollback immediate
go

DROP DATABASE hoteldb
GO


create database
hotelDB
go

alter database hoteldb set MULTI_USER
go
 
--CREATE TABLES
--Create Hotel Table
IF OBJECT_ID(N'hotel', N'U') IS NULL
CREATE TABLE Hotel (
	Hotel_ID  INT PRIMARY KEY,
	Name VARCHAR(255) NOT NULL,
	Address VARCHAR(255) NOT NULL,
	Country VARCHAR(255) NOT NULL,
	Phone_Number VARCHAR(255) NOT NULL,
	Description TEXT
)
Go

--Create Facility_Type table
IF OBJECT_ID(N'Facility_Type', N'U') IS NULL
CREATE TABLE Facility_Type (
	Facility_Type_ID  INT PRIMARY KEY,
	Name VARCHAR(255) NOT NULL,
	Description TEXT,
	Capacity INT CHECK (Capacity > 0)
)
Go

--Create Facility table
IF OBJECT_ID(N'Facility', N'U') IS NULL
CREATE TABLE Facility (
	Facility_ID  INT PRIMARY KEY,
	Hotel_ID INT NOT NULL,
	Name VARCHAR(255) NOT NULL,
	Description TEXT,
	Status VARCHAR(50) NOT NULL,
	Facility_Type_ID INT NOT NULL,
	Foreign Key (Hotel_ID) references Hotel(Hotel_ID),
	Foreign Key (Facility_Type_ID) references Facility_Type(Facility_Type_ID)
	ON UPDATE CASCADE
	ON DELETE CASCADE
)
Go

--Create Service_Category Table
IF OBJECT_ID(N'Service_Category', N'U') IS NULL
CREATE TABLE Service_Category (
	Service_Category_Code INT PRIMARY KEY,
	Name VARCHAR(255) NOT NULL,
	Description TEXT,
	Type_of_Service VARCHAR(100) NOT NULL
)
Go

--Create Service_Item Table
IF OBJECT_ID(N'Service_Item', N'U') IS NULL
CREATE TABLE Service_Item (
	Service_Item_ID INT PRIMARY KEY,
	Hotel_ID INT NOT NULL,
	Facility_Type_ID INT NOT NULL,
	Service_Category_Code INT NOT NULL,
	Name VARCHAR(255) NOT NULL,
	Description TEXT,
	Restrictions TEXT,
	Notes TEXT,
	Comments TEXT,
	Status VARCHAR(50) NOT NULL,
	Available_Times VARCHAR(255) NOT NULL,
	Base_Cost DECIMAL(10,2) NOT NULL CHECK (Base_Cost >=0),
	Base_Currency VARCHAR(10) NOT NULL,
	Capacity INT CHECK (Capacity >= 0),
	Foreign Key (Hotel_ID) references Hotel(Hotel_ID),
	Foreign Key (Facility_Type_ID) references Facility_Type(Facility_Type_ID),
Foreign Key (Service_Category_Code) references Service_Category(Service_Category_Code)
)
go
--Create Employee Table
IF OBJECT_ID(N'Employee', N'U') IS NULL
CREATE TABLE Employee (
	Employee_ID INT PRIMARY KEY,
	Name VARCHAR(255) NOT NULL,
	Position VARCHAR(255) NOT NULL,
	Authorization_Level VARCHAR(100) NOT NULL
)
Go

--Create Package Table
IF OBJECT_ID(N'Package', N'U') IS NULL
CREATE TABLE Package (
	Package_ID INT PRIMARY KEY,
	Hotel_ID INT NOT NULL,
	Employee_ID INT NOT NULL,
	Name VARCHAR(255) NOT NULL,
	Description TEXT,
	Start_Date DATE NOT NULL,
	End_Date DATE NOT NULL,
	Advertised_Price DECIMAL(10,2) NOT NULL CHECK(Advertised_Price >=0),
	Advertised_Currency VARCHAR(10) NOT NULL,
	Inclusions TEXT,
	Exclusions TEXT,
	Status VARCHAR(50) NOT NULL,
	Grace_Period INT NOT NULL CHECK (Grace_Period >=0),
	Foreign Key (Hotel_ID) references Hotel(Hotel_ID),
	Foreign Key (Employee_ID) references Employee(Employee_ID)
)
Go

--Create Customer Table
IF OBJECT_ID(N'Customers', N'U') IS NULL
CREATE TABLE Customers(
	Customer_ID INT PRIMARY KEY NOT NULL,
	Name VARCHAR(255) NOT NULL,
	Address VARCHAR(255) NOT NULL,
	Contact_Number VARCHAR(25) NOT NULL,
	Email VARCHAR(255) NOT NULL UNIQUE,
)
Go

--Create Reservation Table
IF OBJECT_ID(N'Reservation', N'U') IS NULL
CREATE TABLE Reservation(
	Reservation_Number INT PRIMARY KEY NOT NULL,
	Customer_ID INT NOT NULL,
	Payment_Information TEXT NOT NULL,
	Deposit_Charged DECIMAL(10,2) NOT NULL CHECK (Deposit_Charged >=0),
	Foreign Key (Customer_ID) references Customers(Customer_ID))

Go

--Create Booking Table
IF OBJECT_ID(N'Booking', N'U') IS NULL
CREATE TABLE Booking(
	Booking_ID INT PRIMARY KEY,
	Reservation_Number INT NOT NULL,
	Facility_ID  INT NOT NULL,
	Quantity_Booked INT NOT NULL CHECK (Quantity_Booked >=0),
	Start_Date DATE NOT NULL,
	End_Date DATE NOT NULL,
	Guest_Details TEXT NOT NULL,
	Foreign Key (Reservation_Number) references Reservation(Reservation_Number),
	Foreign Key (Facility_ID) references Facility(Facility_ID)
)
Go

--Create Payment Table
IF OBJECT_ID(N'Payment', N'U') IS NULL
CREATE TABLE Payment(
	Payment_ID INT PRIMARY KEY,
	Reservation_Number INT NOT NULL,
	Amount DECIMAL(10,2) NOT NULL CHECK (Amount >=0),
	Payment_Type VARCHAR(255) NOT NULL,
	Payment_Date DATE NOT NULL,
		Foreign Key (Reservation_Number) references Reservation(Reservation_Number)
)
Go

--Create Discount Table
IF OBJECT_ID(N'Discount', N'U') IS NULL
CREATE TABLE Discount(
	Discount_ID INT PRIMARY KEY,
	Reservation_Number INT NOT NULL,
	Discount_Amount DECIMAL(10,2) NOT NULL CHECK (Discount_Amount >=0),
	Authorization_Level_Required VARCHAR(50) NOT NULL,
Foreign Key (Reservation_Number) references Reservation(Reservation_Number)
)
Go

--Create Final Bill Table
IF OBJECT_ID(N'Final_Bill', N'U') IS NULL
CREATE TABLE Final_Bill(
	Bill_ID INT PRIMARY KEY NOT NULL,
	Reservation_Number INT NOT NULL,
	Total_Charges DECIMAL(10,2) NOT NULL CHECK (Total_Charges >=0),
	Deposit_Information TEXT NOT NULL,
	Customer_Payments DECIMAL(10,2) NOT NULL CHECK (Customer_Payments >0),
	Discount_Applied DECIMAL(10,2) NOT NULL CHECK (Discount_Applied >0),
	Foreign Key (Reservation_Number) references Reservation(Reservation_Number)
)
Go


-- DELETE PREVIOUS TABLE SAMPLE DATA AND REFERENCES
DELETE FROM Booking
WHERE Facility_ID IN (SELECT Facility_ID FROM Facility WHERE Hotel_ID IN (1, 2, 3, 4, 5, 6, 7, 8));
DELETE FROM Facility WHERE Hotel_ID IN (1, 2, 3, 4, 5, 6, 7, 8);
DELETE FROM Service_Item WHERE Hotel_ID IN (1, 2, 3, 4, 5, 6, 7, 8);
DELETE FROM Package WHERE Hotel_ID IN (1, 2, 3, 4, 5, 6, 7, 8);
DELETE FROM Hotel WHERE Hotel_ID IN (1, 2, 3, 4, 5, 6, 7, 8);

--Populate Hotel sample data
INSERT INTO Hotel  VALUES (1, 'Bob', '67 Kent St', 'Australia', '0478345', NULL);
INSERT INTO Hotel  VALUES (2, 'Ron', '68 Kent St', 'Germany', '0378345', NULL);
INSERT INTO Hotel  VALUES (3, 'Rob', '69 Lent St', 'Austria', '0478345', NULL);
INSERT INTO Hotel  VALUES (4, 'Rodney', '67 Bent St', 'Denmark', '4478345', NULL);
INSERT INTO Hotel  VALUES (5, 'Pat', '67 Pent St', 'England', '0578345', NULL);
INSERT INTO Hotel  VALUES (6, 'Nick', '67 Kett St', 'Austria', '0478645', NULL);
INSERT INTO Hotel  VALUES (7, 'Tom', '67 Matt St', 'India', '0478395', NULL);
INSERT INTO Hotel  VALUES (8, 'Peter', '67 Durham St', 'Pakistan', '0478399', NULL);
go

-- DELETE PREVIOUS TABLE SAMPLE DATA AND REFERENCES
DELETE FROM Booking WHERE Facility_ID IN (SELECT Facility_ID FROM Facility WHERE Facility_Type_ID IN (1, 2, 3, 4, 5, 6, 7, 8));
DELETE FROM Facility WHERE Facility_Type_ID IN (1, 2, 3, 4, 5, 6, 7, 8);
DELETE FROM Service_Item WHERE Facility_Type_ID IN (1, 2, 3, 4, 5, 6, 7, 8);
DELETE FROM Facility_Type WHERE Facility_Type_ID IN (1, 2, 3, 4, 5, 6, 7, 8);

-- Populate Facility_Type table
INSERT INTO Facility_Type VALUES (1, 'Standard Room', 'A standard room with basic amenities', 2);
INSERT INTO Facility_Type VALUES (2, 'Family Room', 'A spacious room for families', 4);
INSERT INTO Facility_Type VALUES (3, 'Conference Hall', 'A large hall for conferences and events', 50);
INSERT INTO Facility_Type VALUES (4, 'Swimming Pool', 'Outdoor swimming pool', 30);
INSERT INTO Facility_Type VALUES (5, 'Gym', 'Fully equipped gym', 20);
INSERT INTO Facility_Type VALUES (6, 'Restaurant', 'Dining area serving various cuisines', 50);
INSERT INTO Facility_Type VALUES (7, 'Spa', 'Wellness and spa center', 10);
INSERT INTO Facility_Type VALUES (8, 'Bar', 'Evening bar with drinks and snacks', 25);
Go
--Populate Facility Table
INSERT INTO Facility VALUES (1, 1, 'Conference Hall', 'A large hall for conferences and events', 'Available', 1);
INSERT INTO Facility VALUES (2, 1, 'Swimming Pool', 'Outdoor swimming pool', 'Available', 1);
INSERT INTO Facility VALUES (3, 1, 'Gym', 'Fully equipped gym', 'Available', 1);
INSERT INTO Facility VALUES (4, 1, 'Restaurant', 'Dining area serving various cuisines', 'Available', 1);
INSERT INTO Facility VALUES (5, 1, 'Spa', 'Wellness and spa center', 'Available', 1);
INSERT INTO Facility VALUES (6, 1, 'Bar', 'Evening bar with drinks and snacks', 'Available', 1);
INSERT INTO Facility VALUES (7, 1, 'Standard Room', 'A standard room with basic amenities', 'Available', 1);
INSERT INTO Facility VALUES (8, 1, 'Family Suite', 'A spacious room for families', 'Available', 1);
GO

--Delete previous table sample data and references 
DELETE FROM Service_Item WHERE Service_Category_Code IN (1, 2, 3, 4, 5, 6, 7, 8);
DELETE FROM Service_Category WHERE Service_Category_Code IN (1, 2, 3, 4, 5, 6, 7, 8);


-- Populate Service_Category table
INSERT INTO Service_Category VALUES (1, 'Accommodation', 'Room and lodging services', 'Room');
INSERT INTO Service_Category VALUES (2, 'Food & Beverage', 'Dining and drinking services', 'Food');
INSERT INTO Service_Category VALUES (3, 'Recreation', 'Leisure and recreational activities', 'Activity');
INSERT INTO Service_Category VALUES (4, 'Business', 'Services for business needs', 'Business');
INSERT INTO Service_Category VALUES (5, 'Wellness', 'Spa and wellness services', 'Wellness');
INSERT INTO Service_Category VALUES (6, 'Transport', 'Transportation services', 'Transport');
INSERT INTO Service_Category VALUES (7, 'Housekeeping', 'Cleaning and maintenance services', 'Housekeeping');
INSERT INTO Service_Category VALUES (8, 'Event Management', 'Planning and organizing events', 'Event');

Go

-- Populate Service_Item table
INSERT INTO Service_Item VALUES (1, 1, 1, 1, 'Single Standard Room', 'One single bed, basic amenities', 'No pets allowed', 'Popular choice for solo travelers', '', 'Available', '24/7', 100.00, 'AUD', 1);
INSERT INTO Service_Item VALUES (2, 1, 2, 1, 'Family Suite', 'Two double beds, living area', 'No smoking', 'Ideal for families', '', 'Available', '24/7', 200.00, 'AUD', 4);
INSERT INTO Service_Item VALUES (3, 1, 3, 4, 'Business Conference Hall', 'Equipped with projectors and seating', 'Reservation required', 'Catering available on request', '', 'Available', '9am-5pm', 500.00, 'AUD', 50);
INSERT INTO Service_Item VALUES (4, 1, 4, 3, 'Outdoor Pool', 'Heated pool with lounge chairs', 'Children must be supervised', 'Towels provided', '', 'Available', '7am-9pm', 0.00, 'AUD', 30);
INSERT INTO Service_Item VALUES (5, 1, 5, 3, 'Fitness Center', 'Treadmills, weights, and more', 'Gym attire required', 'Personal trainers available', '', 'Available', '6am-10pm', 0.00, 'AUD', 20);
INSERT INTO Service_Item VALUES (6, 1, 6, 2, 'Continental Breakfast', 'Buffet with a variety of choices', 'Served daily', 'Includes coffee and juice', '', 'Available', '6am-10am', 25.00, 'AUD', 50);
INSERT INTO Service_Item VALUES (7, 1, 7, 5, 'Spa Day Pass', 'Access to sauna, steam room, and treatments', 'Booking required', 'Treatments at additional cost', '', 'Available', '10am-6pm', 100.00, 'AUD', 10);
INSERT INTO Service_Item VALUES (8, 1, 8, 2, 'Cocktail Hour', 'Selection of cocktails and appetizers', 'Happy hour specials', 'Live music on weekends', '', 'Available', '5pm-7pm', 15.00, 'AUD', 25);

go
--Delete previous table sample data and references
DELETE FROM Package WHERE Employee_ID IN (1, 2, 3, 4, 5, 6, 7, 8);
DELETE FROM Employee WHERE Employee_ID IN (1, 2, 3, 4, 5, 6, 7, 8);


--Populate Employee Table
INSERT INTO Employee VALUES (1, 'John Smith', 'General Manager', 'High');
INSERT INTO Employee VALUES (2, 'Jane Doe', 'Front Office Manager', 'Medium');
INSERT INTO Employee VALUES (3, 'Alice Johnson', 'Housekeeping Supervisor', 'Low');
INSERT INTO Employee VALUES (4, 'Bob Williams', 'Chef', 'Low');
INSERT INTO Employee VALUES (5, 'Carol Brown', 'Spa Manager', 'Medium');
INSERT INTO Employee VALUES (6, 'David Miller', 'Event Coordinator', 'Medium');
INSERT INTO Employee VALUES (7, 'Emily Wilson', 'Head Waitress', 'Low');
INSERT INTO Employee VALUES (8, 'Frank Thomas', 'Security Chief', 'Low');

Go

-- Populate Package table
INSERT INTO Package VALUES (1, 1, 1, 'Summer Special', '7 nights with breakfast', '2023-06-01', '2023-08-31', 999.00, 'AUD', 'Breakfast included', 'Spa services not included', 'Available', 7);
INSERT INTO Package VALUES (2, 1, 2, 'Winter Getaway', '5 nights with ski pass', '2023-12-01', '2024-02-28', 750.00, 'AUD', 'Ski pass included', 'Equipment rental not included', 'Available', 7);
INSERT INTO Package VALUES (3, 1, 3, 'Business Package', '3 nights with conference access', '2023-09-01', '2023-11-30', 500.00, 'AUD', 'Conference hall access', 'Meals not included', 'Available', 7);
INSERT INTO Package VALUES (4, 1, 4, 'Romantic Retreat', '2 nights with spa treatment', '2023-05-01', '2023-07-31', 400.00, 'AUD', 'Spa treatment for two', 'Dinner not included', 'Available', 7);
INSERT INTO Package VALUES (5, 1, 5, 'Family Fun', '4 nights with theme park tickets', '2023-04-01', '2023-06-30', 800.00, 'AUD', 'Theme park tickets for four', 'Transport not included', 'Available', 7);
INSERT INTO Package VALUES (6, 1, 6, 'Adventure Escape', '6 nights with outdoor activities', '2023-07-01', '2023-09-30', 1200.00, 'AUD', 'Guided hiking and kayaking', 'Equipment rental included', 'Available', 7);
INSERT INTO Package VALUES (7, 1, 7, 'Culinary Experience', '3 nights with cooking classes', '2023-10-01', '2023-12-31', 700.00, 'AUD', 'Cooking classes and wine tasting', 'Ingredients included', 'Available', 7);
INSERT INTO Package VALUES (8, 1, 8, 'Wellness Retreat', '5 nights with yoga sessions', '2023-01-01', '2023-03-31', 850.00, 'AUD', 'Daily yoga and meditation sessions', 'Spa treatments not included', 'Available', 7);

Go

--Delete previous table sample data and references
DELETE FROM Final_Bill WHERE Reservation_Number IN (1, 2, 3, 4, 5, 6, 7, 8);
DELETE FROM Payment WHERE Reservation_Number IN (1, 2, 3, 4, 5, 6, 7, 8);
DELETE FROM Booking WHERE Reservation_Number IN (1, 2, 3, 4, 5, 6, 7, 8);
DELETE FROM Discount WHERE Reservation_Number IN (1, 2, 3, 4, 5, 6, 7, 8);
DELETE FROM Reservation WHERE Reservation_Number IN (1, 2, 3, 4, 5, 6, 7, 8);
DELETE FROM Reservation WHERE Customer_ID IN (1, 2, 3, 4, 5, 6, 7, 8);
DELETE FROM Customers WHERE Customer_ID IN (1, 2, 3, 4, 5, 6, 7, 8);


-- Populate Customer table
INSERT INTO Customers VALUES (1, 'Alice Green', '123 Maple Street', '0423123456', 'alice.green@email.com');
INSERT INTO Customers VALUES (2, 'Bob Brown', '456 Oak Avenue', '0423987654', 'bob.brown@email.com');
INSERT INTO Customers VALUES (3, 'Charlie Black', '789 Pine Road', '0423567890', 'charlie.black@email.com');
INSERT INTO Customers VALUES (4, 'Diane White', '321 Birch Lane', '0423876543', 'diane.white@email.com');
INSERT INTO Customers VALUES (5, 'Evan Red', '654 Cedar Boulevard', '0423765432', 'evan.red@email.com');
INSERT INTO Customers VALUES (6, 'Fiona Yellow', '987 Elm Street', '0423654321', 'fiona.yellow@email.com');
INSERT INTO Customers VALUES (7, 'George Blue', '210 Spruce Avenue', '0423543210', 'george.blue@email.com');
INSERT INTO Customers VALUES (8, 'Hannah Purple', '543 Willow Road', '0423432109', 'hannah.purple@email.com');

Go

-- Populate Reservation table
INSERT INTO Reservation VALUES (1, 1, 'Credit Card', 250.00);
INSERT INTO Reservation VALUES (2, 2, 'Debit Card', 187.50);
INSERT INTO Reservation VALUES (3, 3, 'Credit Card', 300.00);
INSERT INTO Reservation VALUES (4, 4, 'Debit Card', 400.00);
INSERT INTO Reservation VALUES (5, 5, 'Credit Card', 225.00);
INSERT INTO Reservation VALUES (6, 6, 'Debit Card', 350.00);
INSERT INTO Reservation VALUES (7, 7, 'Credit Card', 275.00);
INSERT INTO Reservation VALUES (8, 8, 'Debit Card', 500.00);

Go

-- Populate Booking table
INSERT INTO Booking VALUES (1, 1, 1, 1, '2023-06-10', '2023-06-17', 'Alice Green');
INSERT INTO Booking VALUES (2, 2, 2, 2, '2023-07-05', '2023-07-12', 'Bob Brown');
INSERT INTO Booking VALUES (3, 3, 3, 1, '2023-08-15', '2023-08-22', 'Charlie Black');
INSERT INTO Booking VALUES (4, 4, 4, 1, '2023-09-10', '2023-09-17', 'Diane White');
INSERT INTO Booking VALUES (5, 5, 5, 2, '2023-10-05', '2023-10-12', 'Evan Red');
INSERT INTO Booking VALUES (6, 6, 6, 2, '2023-11-15', '2023-11-22', 'Fiona Yellow');
INSERT INTO Booking VALUES (7, 7, 7, 1, '2023-12-10', '2023-12-17', 'George Blue');
INSERT INTO Booking VALUES (8, 8, 8, 1, '2024-01-05', '2024-01-12', 'Hannah Purple');

Go

-- Populate Payment table
INSERT INTO Payment VALUES (1, 1, 250.00, 'Credit Card', '2023-06-01');
INSERT INTO Payment VALUES (2, 2, 187.50, 'Debit Card', '2023-07-01');
INSERT INTO Payment VALUES (3, 3, 300.00, 'Credit Card', '2023-08-01');
INSERT INTO Payment VALUES (4, 4, 400.00, 'Debit Card', '2023-09-01');
INSERT INTO Payment VALUES (5, 5, 225.00, 'Credit Card', '2023-10-01');
INSERT INTO Payment VALUES (6, 6, 350.00, 'Debit Card', '2023-11-01');
INSERT INTO Payment VALUES (7, 7, 275.00, 'Credit Card', '2023-12-01');
INSERT INTO Payment VALUES (8, 8, 500.00, 'Debit Card', '2024-01-01');

Go

-- Populate Discount table
INSERT INTO Discount VALUES (1, 1, 50.00, 'High');
INSERT INTO Discount VALUES (2, 2, 37.50, 'Medium');
INSERT INTO Discount VALUES (3, 3, 60.00, 'High');
INSERT INTO Discount VALUES (4, 4, 80.00, 'Medium');
INSERT INTO Discount VALUES (5, 5, 45.00, 'High');
INSERT INTO Discount VALUES (6, 6, 70.00, 'Medium');
INSERT INTO Discount VALUES (7, 7, 55.00, 'High');
INSERT INTO Discount VALUES (8, 8, 100.00, 'Medium');

Go

-- Populate Final_Bill table
INSERT INTO Final_Bill VALUES (1, 1, 1000.00, 'Deposit charged: 250.00', 950.00, 50.00);
INSERT INTO Final_Bill VALUES (2, 2, 750.00, 'Deposit charged: 187.50', 712.50, 37.50);
INSERT INTO Final_Bill VALUES (3, 3, 1200.00, 'Deposit charged: 300.00', 1140.00, 60.00);
INSERT INTO Final_Bill VALUES (4, 4, 1600.00, 'Deposit charged: 400.00', 1520.00, 50.00);
INSERT INTO Final_Bill VALUES (4, 4, 1600.00, 'Deposit charged: 400.00', 1520.00, 80.00);
INSERT INTO Final_Bill VALUES (5, 5, 900.00, 'Deposit charged: 225.00', 855.00, 45.00);
INSERT INTO Final_Bill VALUES (6, 6, 1400.00, 'Deposit charged: 350.00', 1330.00, 70.00);
INSERT INTO Final_Bill VALUES (7, 7, 1100.00, 'Deposit charged: 275.00', 1045.00, 55.00);
INSERT INTO Final_Bill VALUES (8, 8, 2000.00, 'Deposit charged: 500.00', 1900.00, 100.00);

GO

