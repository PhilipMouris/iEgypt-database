CREATE Database iEgypt;
go
use  iEgypt;
go
CREATE Table [User]
(
id int identity PRIMARY KEY Not null ,
email VARCHAR (300) check (email like '%@%.com') unique ,
first_name VARCHAR(50) not null ,
middle_name VARCHAR(50) not null ,
last_name VARCHAR(50) not null ,
birth_date datetime not null,
age AS (YEAR(CURRENT_TIMESTAMP) - YEAR(birth_date)),
[password] VARCHAR (50) not null,
deactivate bit default 0,
last_login datetime

);

CREATE Table Viewer 
(
id int NOT NULL primary key foreign key references [User](id) ON DELETE CASCADE ON UPDATE CASCADE,
working_place varchar(50) ,
working_place_type varchar(50),
working_place_description varchar(200)
)

CREATE Table Notified_Person
(
id int identity primary key not null
)

CREATE Table Contributor(
id int NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES [User](id) ON DELETE CASCADE ON UPDATE CASCADE,
years_of_experience int,
portofolio_link varchar(max),
specialization varchar(50),
notified_id int FOREIGN KEY REFERENCES Notified_Person(id)
)

CREATE Table Staff(
id int NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES [User](id) ON DELETE CASCADE ON UPDATE CASCADE,
Hire_date datetime not null,
working_hours int ,
payment_rate decimal(20,4) ,
total_salary AS (working_hours*payment_rate),
notified_id int FOREIGN KEY REFERENCES Notified_Person(id)
)
CREATE Table Content_type(
[type] varchar(50) primary key not null
)
CREATE Table Content_manager(
id int NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES staff(id) ON DELETE CASCADE ON UPDATE CASCADE,
[type] varchar(50) not null foreign key references content_type([type]) 
)
CREATE Table Reviewer(
id int NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES staff(id) ON DELETE CASCADE ON UPDATE CASCADE
)
CREATE table [Message](
sent_at datetime not null , 
contributer_id int foreign key references contributor(id) not null,
viewer_id int foreign key references viewer(id) not null,
sender_type bit not null, --if the sender is of type viewer then the bit=0 else bit =1
read_at datetime ,
message_text varchar(max),
read_status bit Not Null default 0,
PRIMARY KEY(sent_at,contributer_id,viewer_id,sender_type)
)
CREATE table Category(
[type] varchar(50) primary key not null,
[description] varchar(max)
)
CREATE table sub_category(
category_type varchar(50) foreign key references category([type]) ON DELETE CASCADE ON UPDATE CASCADE,
[name] varchar(50) not null,
Primary key( category_type, [name])
)
CREATE table notification_object(
id int identity primary key not null
)
CREATE table content(
id int identity primary key,
link varchar(200),
uploaded_at datetime default CURRENT_TIMESTAMP,
category_type varchar(50) not null,
contributer_id int foreign key references contributor(id)  not null ,
subcategory_name varchar(50) not null,
foreign key(category_type, subcategory_name) references sub_category(category_type, [name]) ,
[type] varchar(50) foreign key references content_type([type])
)
CREATE table Original_content(
id int primary key foreign key references content(id) ON DELETE CASCADE ON UPDATE CASCADE,
content_manager_id int foreign key references content_manager(id),
reviewer_id int foreign key references reviewer(id),
review_status bit,  
filter_status bit,
rating int check (rating<6 and rating>=0)
)
CREATE table existing_Request(
id int identity primary key,
original_content_id int foreign key references original_content(id) ON DELETE CASCADE ON UPDATE CASCADE not null,
viewer_id int foreign key references viewer(id) ON DELETE CASCADE ON UPDATE CASCADE not null
)
CREATE table new_request(
id int identity primary key,
accept_status bit,
specified bit,
information varchar(max),
viewer_id int foreign key references viewer(id) ON DELETE CASCADE ON UPDATE CASCADE not null,
notif_obj_id int foreign key references notification_object(id) ,
contributer_id int foreign key references contributor(id),
accepted_at datetime
)
CREATE table New_content(
id int primary key foreign key references content(id) ON DELETE CASCADE ON UPDATE CASCADE,
new_request_id int foreign key references new_request(id) ON DELETE CASCADE ON UPDATE CASCADE not null
)
Create table Comment(
viewer_id int foreign key references viewer(id) ,
original_content_id int foreign key references original_content(id) ON DELETE CASCADE ON UPDATE CASCADE,
[date] datetime,
primary key( viewer_id,original_content_id,[date]),
[text] varchar(max)
)
Create table Rate(
viewer_id int foreign key references viewer(id) ,
original_content_id int foreign key references original_content(id) ON DELETE CASCADE ON UPDATE CASCADE,
[date] datetime,
Rate decimal(10,2) check (rate>=0 and rate <=5),
primary key(viewer_id,original_content_id)
)
CREATE table [event](
id int primary key identity,
[description] varchar(max),
[location] varchar(500),
City varchar(50),
[time] datetime,
entertainer varchar(50),
notif_obj_id int foreign key references notification_object(id) ,
viewer_id int foreign key references viewer(id) not null
)
Create table Event_photos_link (
event_id int foreign key references [event](id) ON DELETE CASCADE ON UPDATE CASCADE,
link varchar(200),
primary key (event_id,link)
)
Create table Event_videos_link(
event_id int foreign key references [event](id) ON DELETE CASCADE ON UPDATE CASCADE,
link varchar(500),
primary key (event_id,link)
)
Create Table advertisement(
id int identity primary key,
[description] varchar(max),
[location] varchar(500),
event_id int foreign key references [event](id) ,
viewer_id int foreign key references viewer(id)  not null
)
Create table Ads_video_link (
advertisement_id int foreign key references advertisement(id) ON DELETE CASCADE ON UPDATE CASCADE,
link varchar(500),
primary key (advertisement_id,link)
)
Create table Ads_photos_link(
advertisement_id int foreign key references advertisement(id) ON DELETE CASCADE ON UPDATE CASCADE,
link varchar(500),
primary key (advertisement_id,link)
)
Create table Announcement(
id int identity primary key,
seen_at datetime,
sent_at datetime,
notified_person_id int foreign key references notified_person(id) ON DELETE CASCADE ON UPDATE CASCADE not null,
notification_object_id int foreign key references notification_object(id) ON DELETE CASCADE ON UPDATE CASCADE not null
)
