﻿CREATE DATABASE banks_system
GO

USE banks_system
GO

CREATE TABLE social_statuses
(
	social_status_id		INT PRIMARY KEY IDENTITY,
	sotial_status_family	BIT NOT NULL,
	sotial_status_work		BIT NOT NULL,
	sotial_status_salary	MONEY NULL
);

CREATE TABLE clients_info
(
	client_info_id			INT PRIMARY KEY IDENTITY,
	client_info_surname		NVARCHAR(50) NOT NULL,
	client_info_name		NVARCHAR(50) NOT NULL,
	client_info_patronymic	NVARCHAR(50) NOT NULL,
	client_info_passport	NVARCHAR(9) NOT NULL,
);

CREATE TABLE clients
(
	client_id				INT PRIMARY KEY IDENTITY,
	social_status_id		INT UNIQUE NOT NULL,
	clients_info_id			INT UNIQUE NOT NULL,
	CONSTRAINT FK_clients_clientsInfo_clientInfoId
		FOREIGN KEY(clients_info_id) REFERENCES clients_info (client_info_id),
	CONSTRAINT FK_clients_socialStatuses_socialStatusId
		FOREIGN KEY(social_status_id) REFERENCES social_statuses (social_status_id)
);

CREATE TABLE cities
(
	city_id					INT PRIMARY KEY IDENTITY,
	city_name				NVARCHAR(50) UNIQUE CHECK(city_name !='') NOT NULL
);

CREATE TABLE banks
(
	bank_id					INT PRIMARY KEY IDENTITY,
	bank_name				NVARCHAR(50) UNIQUE NOT NULL,
	bank_description		NVARCHAR(100) NULL
);

CREATE TABLE branches
(
	branch_id				INT PRIMARY KEY IDENTITY,
	branch_name				NVARCHAR(50) NOT NULL,
	branch_created_at		DATE NOT NULL,
	city_id					INT NOT NULL,
	bank_id					INT NOT NULL,
	CONSTRAINT FK_branches_cities_cityId 
		FOREIGN KEY(city_id) REFERENCES cities (city_id),
	CONSTRAINT FK_branches_banks_bankId
		FOREIGN KEY(bank_id) REFERENCES banks (bank_id)
);

CREATE TABLE accounts
(
	account_id				INT PRIMARY KEY IDENTITY,
	account_login			VARCHAR(50) UNIQUE NOT NULL,
	account_password		VARCHAR(50) NOT NULL,
	client_id				INT,
	bank_id					INT, 
	UNIQUE(client_id, bank_id),
	CONSTRAINT FK_accounts_clients_accountId
		FOREIGN KEY(client_id) REFERENCES clients (client_id),
	CONSTRAINT FK_accounts_banks_bankId
		FOREIGN KEY(bank_id) REFERENCES banks (bank_id)
);

CREATE TABLE cards
(
	card_id					INT PRIMARY KEY IDENTITY,
	card_number				VARCHAR(16) UNIQUE CHECK(card_number !='') NOT NULL,
	card_valid_date			DATE NOT NULL,
	card_balance			INT NULL,
	account_id				INT NOT NULL,
	CONSTRAINT FK_cards_accounts_accountId 
		FOREIGN KEY(account_id) REFERENCES accounts (account_id),
);

CREATE TABLE clients_banks
(
	client_id				INT NOT NULL,
	bank_id					INT NOT NULL,
	UNIQUE(client_id, bank_id),
	CONSTRAINT FK_clientsBanks_clients_clientId
		FOREIGN KEY(client_id) REFERENCES clients (client_id),
	CONSTRAINT FK_clientsBanks_banks_bankId
		FOREIGN KEY(bank_id) REFERENCES banks (bank_id)
);
GO

ALTER TABLE accounts
ADD account_balance			INT NULL;
GO

INSERT INTO cities (city_name)
	VALUES ('Minsk'),
		   ('Brest'),
		   ('Grodno'),
		   ('Vitebsk'),
		   ('Mohilov'),
		   ('Homel');

INSERT INTO banks (bank_name, bank_description)
	VALUES ('Alfa', 'Good bank'),
		   ('BSB', 'Good bank'),
		   ('Belarus', 'Good bank'),
		   ('BelAgroProm', 'Good bank'),
		   ('Privat', 'Good bank');

INSERT INTO branches (branch_name, branch_created_at, city_id, bank_id)
	VALUES ('Alfa-Minsk', '2015-10-29', 1, 1),
		   ('Alfa-Brest', '2020-1-1', 2, 1),
		   ('BSB-Grodno', '2018-6-6', 3, 2),
		   ('Belarus-Brest', '2011-12-12', 2, 3),
		   ('BelAgroProm-Vitebsk', '2015-3-4', 4, 4),
		   ('Privat-Mohilov', '2017-5-13', 5, 5);

INSERT INTO social_statuses (sotial_status_family, sotial_status_work, sotial_status_salary)
	VALUES (1, 1, 5000),
		   (0, 1, 100),
		   (0, 1, 3000),
		   (1, 0, NULL),
		   (1, 1, 900);

INSERT INTO clients_info (client_info_surname, client_info_name, client_info_patronymic, client_info_passport)
	VALUES ('Hatsko', 'Artem', 'Aliaksandovich', 'HB1234567'),
		   ('Dvornik', 'Maksim', 'Sergeevich', 'HB3456789'),
		   ('Kovalov', 'Vladislav', 'Denisovich', 'HB4567890'),
		   ('Shukin', 'Daniil', 'Vladimirovich', 'HB2345678'),
		   ('Diatlov', 'Valerii', 'Petrovich', 'HB5678901');

INSERT INTO clients (social_status_id, clients_info_id)
	VALUES (1, 1),
		   (2, 2), 
		   (3, 3),
		   (4, 4), 
		   (5, 5);

INSERT INTO accounts (account_login, account_password, client_id, bank_id)
	VALUES ('user1', 'user1', 1, 1),
		   ('user2', 'user2', 2, 2),
		   ('user3', 'user3', 3, 3),
		   ('user4', 'user4', 4, 4),
		   ('user5', 'user5', 5, 5),
		   ('user6', 'user6', 1, 2);

INSERT INTO cards (card_number, card_valid_date, card_balance, account_id)
	VALUES ('1234123412341234', '2023-10-29', 2034, 1),
		   ('4321432143214321', '2024-8-10', 100, 2),
		   ('5678567856785678', '2022-10-1', 5980, 3),
		   ('8765876587658765', '2023-12-5', 1234, 4),
		   ('3456345634563456', '2025-10-29', 4321, 5);
		   
INSERT INTO clients_banks (client_id, bank_id)
	VALUES (1, 1),
		   (2, 2),
		   (3, 3),
		   (4, 4),
		   (5, 5);
GO

UPDATE accounts
SET account_balance = 6000;
GO

INSERT INTO cards (card_number, card_valid_date, card_balance, account_id)
	VALUES ('3456345634566345', '2023-10-29', 3966, 1),
		   ('9485948594859458', '2022-10-1', 20, 3);
GO

SELECT bank_name
FROM banks
	JOIN branches ON banks.bank_id = branches.bank_id
	JOIN cities ON cities.city_id = branches.city_id
WHERE cities.city_name = 'Brest';
GO

SELECT card_number, clients_info.client_info_surname  + ' ' + clients_info.client_info_name + ' ' + clients_info.client_info_patronymic AS client_name, cards.card_balance, banks.bank_name
FROM cards
	JOIN accounts ON accounts.account_id = cards.card_id
	JOIN banks ON banks.bank_id = accounts.bank_id
	JOIN clients ON clients.client_id = accounts.client_id
	JOIN clients_info ON clients_info.client_info_id = clients.clients_info_id;
GO

SELECT accounts.account_login, accounts.account_balance - SUM(cards.card_balance) AS difference
FROM accounts
	JOIN cards ON cards.account_id = accounts.account_id
GROUP BY accounts.account_login, accounts.account_balance
HAVING accounts.account_balance != SUM(cards.card_balance);
GO