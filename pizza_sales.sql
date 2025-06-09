CREATE DATABASE PIZZA_SALES;

CREATE TABLE ORDERS (order_id INT NOT NULL,
order_date DATE not null,
order_time TIME not null,
Primary key(order_id));

CREATE TABLE order_details (order_details_id INT NOT NULL,
order_id int not null,
pizza_id text not null,
quantity int not null,
Primary key(order_details_id));

-- Easy Level

# Objective1:- Retrieve the total number of orders placed.
select count(order_id) as order_placed from orders;

# Objective2:- Calculate the total revenue generated from pizza sales.
Select round(sum(order_details.quantity * pizzas.price),2) as Total_revenue from order_details join pizzas ON order_details.pizza_id=pizzas.pizza_id;

#Objective3:-Identify the highest-priced pizza.
select pizza_types.name as Pizza_name,pizzas.price as costly_pizza from pizza_types join pizzas on pizza_types.pizza_type_id=pizzas.pizza_type_id order by costly_pizza DESC limit 1;

# Objective4:-Identify the most common pizza size ordered.
SELECT 
    pizzas.size,
    COUNT(order_details.order_details_id) AS count_of_pizza
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY count_of_pizza DESC
LIMIT 1;

# Objective5:-List the top 5 most ordered pizza types along with their quantities.
SELECT 
    pizza_types.name, SUM(order_details.quantity)
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY SUM(order_details.quantity) DESC
LIMIT 5;

-- Intermediate Level

# Objective6:-Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT 
    pizza_types.category AS Category,
    SUM(order_details.quantity) AS quantity
FROM
    pizzas
        JOIN
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY Category;

# objective10:-Determine the top 3 most ordered pizza types based on revenue.
SELECT 
    pizza_types.name AS pizza_name,
    SUM(order_details.quantity * pizzas.price) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_name
ORDER BY revenue DESC
LIMIT 3;

# Objective7:-Determine the distribution of orders by hour of the day.
SELECT 
    HOUR(order_time), COUNT(order_id)
FROM
    orders
GROUP BY HOUR(order_time);

# Objective8:-Join relevant tables to find the category-wise distribution of pizzas.
SELECT 
    pizza_types.category AS category,
    SUM(order_details.quantity)
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY category;

# Objective9:-Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT 
    ROUND(AVG(qunatity), 0) AS avg_pizza_perday
FROM
    (SELECT 
        orders.order_date, SUM(order_details.quantity) AS qunatity
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date) AS order_quantity;

-- Hard Level

# Objective11:-Calculate the percentage contribution of each pizza type to total revenue.
 SELECT 
    pizza_types.category AS Category,
    ROUND((SUM(pizzas.price * order_details.quantity) / (SELECT 
                    ROUND(SUM(order_details.quantity * pizzas.price),
                                2) AS Total_revenue
                FROM
                    order_details
                        JOIN
                    pizzas ON order_details.pizza_id = pizzas.pizza_id)),
            2) * 100 AS percentage_contribute
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY Category;
 
 # Objective12:-Analyze the cumulative revenue generated over time.
 select dates,round(sum(revenue) over (order by dates),2) as cumulative_revenue from
(select orders.order_date as dates,round(sum(pizzas.price * order_details.quantity),2) as revenue from pizza_types join pizzas 
on pizza_types.pizza_type_id=pizzas.pizza_type_id join order_details 
on pizzas.pizza_id=order_details.pizza_id join orders 
on order_details.order_id=orders.order_id group by dates) as daily_revenue;
