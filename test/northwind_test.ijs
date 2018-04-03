NB. Copyright 2014, Jsoftware Inc.  All rights reserved.

northwind_tests=: 3 : 0
drd'Description from Categories order by Description'
assert 8 58-:$;{:R
drd'Address,City from Suppliers where Country="UK" order by City'
dassert 'Address';'49 Gilbert St.29 King''s Way ';2 14
dassert 'City';'London    Manchester';2 10
drd'ProductName,Categories.CategoryName from Products,Products.Categories where Categories.CategoryName="Beverages" order by ProductName'
dassert 'ProductName';'';12 25
drd'Products.ProductName,Suppliers.City from Products,Products.Suppliers where Suppliers.CompanyName="Exotic Liquids" order by Products.ProductName'
dassert 'Products.ProductName';'Aniseed SyrupChai         Chang        ';3 13
dassert 'Suppliers.City';'LondonLondonLondon';3 6
drd'ProductName,UnitPrice from Products where UnitPrice<10 order by ProductName'
dassert 'UnitPrice';7 2.5 4.5 9.65 6 7.75 9.5 9.2 7.45 9 9.5;11 1
drd'Suppliers.Country,Categories.CategoryName from Products,Products.Categories,Products.Suppliers where Suppliers.Country="UK" order by Categories.CategoryName'
dassert 'Suppliers.Country';'UKUKUKUKUKUKUK';7 2
dassert 'Categories.CategoryName';'Beverages  Beverages  Condiments ConfectionsConfectionsConfectionsConfections';7 11
drd'CustomerID from Customers where Country="UK" order by CustomerID'
dassert 'CustomerID';'AROUT     BSBEV     CONSH     EASTC     ISLAT     NORTS     SEVES     ';7 10
drd'Country,HireDate from Employees where Country<>"UK" and HireDate>19930000 order by HireDate'
dassert 'Country';'USAUSAUSAUSAUSA';5 3
dassert 'HireDate';19920401000000 19920501000000 19920814000000 19930503000000 19940305000000;5 1
drd'from Shippers order by CompanyName'
dassert 'ShipperID';3 1 2;3 1
drd'Customers.Country,Employees.Country,Shippers.ShipperID from Orders,Orders.Customers,Orders.Employees,Orders.Shippers where Customers.Country="UK" and Employees.Country="UK" and Shippers.ShipperID=1'
dassert 'Customers.Country';'UKUKUK';3 2
dassert 'Employees.Country';'UKUKUK';3 2
dassert 'Shippers.ShipperID';1 1 1;3 1
drd'Customers.Country,OrderDetails.Quantity from OrderDetails,OrderDetails.Orders.Customers where Customers.Country="UK" and OrderDetails.Quantity>60 order by OrderDetails.Quantity'
dassert 'Customers.Country';'UKUKUK';3 2
dassert 'OrderDetails.Quantity';70 80 80;3 1
drd'count:count Country by Country from Suppliers order by Country'
dassert 'count';2 1 2 1 1 3 3 2 2 1 1 1 1 1 1 2 4;17 1
dassert 'Country';'Australia  Brazil     Canada     Denmark    Finland    France     Germany    Italy      ';17 11
drd'min:min UnitsInStock,max:max UnitsInStock by Suppliers.Country from Products,Products.Suppliers order by Suppliers.Country'
dassert 'min';0 20 17 5 10 17 0 0 4 15 26 17 22 11 61 3 0;17 1
dassert 'max';42 20 115 95 65 79 125 36 39 36 112 27 86 112 104 40 123;17 1
dassert 'Suppliers.Country';'Australia  Brazil     Canada     Denmark    Finland    France     Germany    Italy      ';17 11
)

jdadmin'northwind'
ALLR=: ''
northwind_tests''
ALLRNORTHWIND=: ALLR

jdadmin'northwind_shuffle'
ALLR=: ''
northwind_tests''
ALLRNORTHWINDSHUFFLE=: ALLR

assert ALLRNORTHWIND-:ALLRNORTHWINDSHUFFLE
