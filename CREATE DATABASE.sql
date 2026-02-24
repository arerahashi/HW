/*CREATE DATABASE HW_CashOrderService;
GO*/
USE HW_CashOrderService;
GO


-- Клиенты
CREATE TABLE clients (
    client_id INT PRIMARY KEY IDENTITY(1,1),
    full_name NVARCHAR(200) NOT NULL,
    phone NVARCHAR(30) NOT NULL,
    document_number NVARCHAR(50) NOT NULL,
    address NVARCHAR(300),
    created_at DATETIME2 NOT NULL,
    client_status NVARCHAR(50) NOT NULL
);

-- Отделения
CREATE TABLE branches (
    branch_id INT PRIMARY KEY IDENTITY(1,1),
    branch_code NVARCHAR(30) NOT NULL,
    address NVARCHAR(300) NOT NULL,
    phone NVARCHAR(30),
    branch_status NVARCHAR(50) NOT NULL
);

-- Справочник статусов
CREATE TABLE order_statuses (
    status_id INT PRIMARY KEY IDENTITY(1,1),
    status_name NVARCHAR(100) NOT NULL
);

-- Справочник каналов уведомлений
CREATE TABLE notification_channels (
    channel_id INT PRIMARY KEY IDENTITY(1,1),
    channel_name NVARCHAR(50) NOT NULL
);

-- Заказы наличных
CREATE TABLE cash_orders (
    order_id INT PRIMARY KEY IDENTITY(1,1),
    client_id INT NOT NULL,
    branch_id INT NOT NULL,
    status_id INT NOT NULL,
    commission DECIMAL(18,2) NOT NULL,
    created_at DATETIME2 NOT NULL,
    finished_at DATETIME2,
    order_amount DECIMAL(18,2) NOT NULL,
    currency CHAR(3) NOT NULL,

    CONSTRAINT FK_cash_orders_clients 
        FOREIGN KEY (client_id) REFERENCES clients(client_id),

    CONSTRAINT FK_cash_orders_branches 
        FOREIGN KEY (branch_id) REFERENCES branches(branch_id),

    CONSTRAINT FK_cash_orders_statuses 
        FOREIGN KEY (status_id) REFERENCES order_statuses(status_id)
);

-- История статусов
CREATE TABLE order_status_history (
    history_id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT NOT NULL,
    status_id INT NOT NULL,
    status_date DATETIME2 NOT NULL,

    CONSTRAINT FK_history_orders 
        FOREIGN KEY (order_id) REFERENCES cash_orders(order_id),

    CONSTRAINT FK_history_statuses 
        FOREIGN KEY (status_id) REFERENCES order_statuses(status_id)
);

-- Уведомления
CREATE TABLE notifications (
    notification_id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT NOT NULL,
    channel_id INT NOT NULL,
    notification_text NVARCHAR(500) NOT NULL,
    created_at DATETIME2 NOT NULL,
    is_sent BIT NOT NULL,

    CONSTRAINT FK_notifications_orders 
        FOREIGN KEY (order_id) REFERENCES cash_orders(order_id),

    CONSTRAINT FK_notifications_channels 
        FOREIGN KEY (channel_id) REFERENCES notification_channels(channel_id)
);

