NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. demos built by jdtests''

load'~addons/data/jd/demo/common.ijs'
setdemodb'northwind'

drd'Description from Categories'
assert 8 58-:$;{:R
drd'Address,City from Suppliers where Country="UK"'
dassert 'Address';'49 Gilbert St.29 King''s Way ';2 14
dassert 'City';'London    Manchester';2 10
drd'ProductName,Categories.CategoryName from Products,Products.Categories where Categories.CategoryName="Beverages"'
dassert 'ProductName';'';12 25
drd'Products.ProductName,Suppliers.City from Products,Products.Suppliers where Suppliers.CompanyName="Exotic Liquids"'
dassert 'Products.ProductName';'Chai         Chang        Aniseed Syrup';3 13
dassert 'Suppliers.City';'LondonLondonLondon';3 6
drd'ProductName,UnitPrice from Products where UnitPrice<10'
dassert 'ProductName';'Konbu                          Teatime Chocolate Biscuits     Tunnbrod';11 31
dassert 'UnitPrice';6 9.1999999999999993 9 4.5 2.5 9.6500000000000004 9.5 9.5 7 7.4500000000000002 7.75;11 1
drd'Suppliers.Country,Categories.CategoryName from Products,Products.Categories,Products.Suppliers where Suppliers.Country="UK"'
dassert 'Suppliers.Country';'UKUKUKUKUKUKUK';7 2
dassert 'Categories.CategoryName';'Beverages  Beverages  Condiments ConfectionsConfectionsConfectionsConfections';7 11
drd'CustomerID from Customers where Country="UK"'
dassert 'CustomerID';'AROUT     BSBEV     CONSH     EASTC     ISLAT     NORTS     SEVES     ';7 10
drd'Country,HireDate from Employees where Country<>"UK" and HireDate>19930000'
dassert 'Country';'USAUSAUSAUSAUSA';5 3
dassert 'HireDate';19920501000000 19920814000000 19920401000000 19930503000000 19940305000000;5 1
drd'from Shippers'
dassert 'ShipperID';1 2 3;3 1
drd'Customers.Country,Employees.Country,Shippers.ShipperID from Orders,Orders.Customers,Orders.Employees,Orders.Shippers where Customers.Country="UK" and Employees.Country="UK" and Shippers.ShipperID=1'
dassert 'Customers.Country';'UKUKUK';3 2
dassert 'Employees.Country';'UKUKUK';3 2
dassert 'Shippers.ShipperID';1 1 1;3 1
drd'Customers.Country,OrderDetails.Quantity from OrderDetails,OrderDetails.Orders.Customers where Customers.Country="UK" and OrderDetails.Quantity>60'
dassert 'Customers.Country';'UKUKUK';3 2
dassert 'OrderDetails.Quantity';70 80 80;3 1
drd'count:count Country by Country from Suppliers'
dassert 'count';2 4 2 1 2 1 1 3 2 1 1 3 1 1 1 1 2;17 1
dassert 'Country';'UK         USA        Japan      Spain      Australia  Sweden     Brazil';17 11
drd'min:min UnitsInStock,max:max UnitsInStock by Suppliers.Country from Products,Products.Suppliers'
dassert 'min';3 0 4 22 0 61 20 0 0 26 11 17 17 5 15 10 17;17 1
dassert 'max';40 123 39 86 42 104 20 125 36 112 112 79 27 95 36 65 115;17 1
dassert 'Suppliers.Country';'UK         USA        Japan      Spain      Australia  Sweden     Brazil';17 11
