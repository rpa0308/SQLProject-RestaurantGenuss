# SQLProject-RestaurantGenuss

### **Project Description: Restaurant Management Database**  

A modern restaurant requires a well-structured and efficient database to manage all key business processes. The central database consists of multiple interconnected tables that represent various aspects of restaurant operations.  

At the core of the system are the **customers(Gäste)**, who register with their personal information, such as name, phone number, and email address. These details are essential for managing **reservations, orders, and customer relationships**. **Reservations(Reservierungen)** store details such as date, time, number of guests, and the assigned table. Each reservation is linked to a specific customer to ensure a smooth service process.  

The **menu(Menü)** consists of a structured list of dishes, each identified by a unique ID. Every dish is stored with its **name, description, price, and category** (e.g., appetizer, main course, or dessert). To allow customers to place orders, the database includes an **orders(Bestellungen)** entity that records the **customer, order time, and current status** (e.g., "in progress" or "served"). Each order is linked to multiple dishes, with quantity information indicating how many units of each dish were ordered.  

To track the restaurant’s financial transactions, **payments** are stored separately. Each payment is linked to an order and includes details such as **payment method** (e.g., cash or credit card).  

Through this well-structured database, the restaurant can efficiently organize its operations, enhance customer service, and ensure clear tracking of **orders, reservations, and payments**. This approach maintains transparency and simplifies business management.
