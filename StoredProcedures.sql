use iegypt
go
--1, query that searches for original content with both attributes (filter and review status)=1
create procedure Original_Content_Search @typename varchar (max) ,@categoryname varchar (max) 
as
select * from Original_content,content 
where review_status=1 and filter_status=1 and ([type]=@typename or category_type=@categoryname) and Original_content.id=content.id
go
--2 searches by fullname for contributor
create procedure Contributor_Search @fullname varchar (max) 
as
select * from contributor,[User] where @fullname=first_name+' '+middle_name+' '+last_name and [User].id=contributor.id
go
--3 inserts into user then checks the type, then inserts into each subclass of user unless content manager, in this case we wait for the type in check type procedure
CREATE procedure Register_User @usertype varchar (max) ,@email varchar (max) ,@password varchar (max) ,@firstname varchar (max) ,@middlename varchar (max) ,@lastname varchar (max)
,@birth_date datetime,@working_place_name varchar (max) ,@working_place_type varchar (max) ,@working_place_description varchar (max),@specilization varchar (max) ,
@portofolio_link varchar (max) ,@years_experience int, @hire_date datetime,@working_hours int,@payment_rate float,@user_id int OUTPUT
as
if exists (select * from [user] where email=@email)
print('This Email is already taken');
begin try
if not exists (select * from [user] where email=@email) begin
insert into [user] (email,first_name,middle_name,last_name,birth_date,[password]) values (@email,@firstname,@middlename,@lastname,@birth_date,@password);
SET @user_id=SCOPE_IDENTITY();
if (@usertype='Viewer')
insert into [Viewer] (id,working_place,working_place_type,working_place_description) values (@user_id,@working_place_name,@working_place_type,@working_place_description);
else
if (@usertype='Contributor' or @usertype='Contributer')
begin
insert into Notified_Person default values ;
insert into [contributor] (id,years_of_experience,portofolio_link,specialization,notified_id) values (@user_id,@years_experience,@portofolio_link,@specilization,SCOPE_IDENTITY());
end
else 
if(@usertype='Authorized Reviewer' or @usertype='Content Manager')
begin
insert into Notified_Person default values ;
insert into staff (id,hire_date,working_hours,payment_rate,notified_id) values (@user_id,@hire_date,@working_hours,@payment_rate,SCOPE_IDENTITY())
if (@usertype='Authorized Reviewer')
insert into [reviewer] values (@user_id)
end
end
end try
begin catch
print(error_message());
set @user_id=-1;
end catch
go
--4 as the column type is not null, so we must wait for this procedure to insert the content manager into the content table manager
create procedure Check_Type @typename varchar (max),@content_manager_id int
as
if exists (select * from Content_type where [type]=@typename) and exists (select * from Staff where id=@content_manager_id)
begin
insert into Content_manager values (@content_manager_id,@typename);
end
else 
begin
insert into Content_type values (@typename);
if exists (select * from Staff where id=@content_manager_id)
insert into [content_manager]  values (@content_manager_id,@typename);
END
go
--5 orders contributors descendingly
CREATE procedure Order_Contributor
as
select * from contributor,[User] where Contributor.id=[user].id order by years_of_experience desc;
go
--6 checks if the ID is null, if it is then we select all original content ,otherwise we only get those of the specified contributor
create procedure Show_Original_Content @contributor_id int
as
if(@contributor_id is not null)
select * from Original_content,content,contributor,[user] where [user].id=@contributor_id and contributor.id=@contributor_id and content.contributer_id=@contributor_id
and Original_content.id=content.id and review_status=1 and filter_status=1;
else
select * from Original_content,content,contributor,[user] where [user].id=contributor.id and content.contributer_id=contributor.id
and Original_content.id=content.id and review_status=1 and filter_status=1;
go
--page 3 number 1 ,checks all cases that allow user to login then gets the user_id and updates last_login, otherwise user_id=-1
CREATE procedure User_login @email varchar (max) ,@password varchar (max) ,@user_id int OUTPUT 
as
declare 
@temp_id int
if not exists (select * from [User] where email=@email)
print('Email is not registered')
else
if exists(select * from [user] where email=@email )and not exists(select * from [User] where email=@email and password=@password)
print('Incorrect Password')
else if exists (select * from [User] where email=@email and password=@password  and (cast(CURRENT_TIMESTAMP- last_login as date))>'1900-01-14')
print ('Your Account is deactivated for more than to weeks')
if exists (select id from [user] where email=@email and [password]=@password and deactivate=0 or (deactivate=1 and (cast(CURRENT_TIMESTAMP- last_login as date))<'1900-01-14'))
begin
select	@temp_id=id from [user] where email=@email and [password]=@password
if exists (select * from [content_manager] where id=@temp_id ) or exists (select * from [reviewer] where id=@temp_id)
or exists (select * from [viewer] where id=@temp_id)or exists (select * from [contributor] where id=@temp_id) begin
set @user_id=@temp_id
update [user] set deactivate=0,last_login=CURRENT_TIMESTAMP where id=@user_id;
end
else begin set @user_id=-1 end
end
else 
set @user_id=-1
go
--page 3 number 2 gets all details of user as output
create procedure Show_Profile
@user_id int, @email varchar (max)  OUTPUT, @password varchar (max)  OUTPUT, @firstname varchar (max)  OUTPUT, @middlename varchar (max)  OUTPUT,
@lastname varchar (max)  OUTPUT, @birth_date datetime OUTPUT, @working_place_name varchar (max)  OUTPUT, @working_place_type varchar (max)  OUTPUT, @working_place_description
varchar (max)  OUTPUT, @specilization varchar (max)  OUTPUT,
@portofolio_link varchar (max)  OUTPUT, @years_experience int OUTPUT, @hire_date datetime OUTPUT, @working_hours int
OUTPUT, @payment_rate float OUTPUT
as
if exists(select * from [user] where id=@user_id and not (deactivate=1 and (cast(CURRENT_TIMESTAMP- last_login as date))<'1900-01-14'))
begin
select @email=email,@password=[password],@firstname=first_name,@middlename=middle_name,@lastname=last_name,@birth_date=birth_date from [user] where id=@user_id
if exists(select * from [viewer] where id =@user_id)
select @working_place_name=working_place ,@working_place_type=working_place_type,@working_place_description=working_place_description from Viewer where id=@user_id
else
if exists(select * from [contributor] where id =@user_id)
select @years_experience=years_of_experience,@specilization=specialization,@portofolio_link=portofolio_link from contributor where id=@user_id
if exists(select * from staff where id =@user_id)
select @hire_date=hire_date,@working_hours=working_hours,@payment_rate=payment_rate from staff where id=@user_id
end
go
--page 3 number 3 updates all tables with new info
create procedure Edit_Profile @user_id int, @email varchar (max) , @password varchar (max),
@firstname varchar (max) , @middlename varchar (max) , @lastname varchar (max), @birth_date datetime, @working_place_name varchar (max), @working_place_type varchar (max) ,
@wokring_place_description varchar (max) , @specilization varchar (max), @portofolio_link varchar (max) , @years_experience int, @hire_date datetime,
@working_hours int, @payment_rate float
as
update [User] set email=@email,[password]=@password,first_name=@firstname,middle_name=@middlename,last_name=@lastname,birth_date=@birth_date where id=@user_id
update [Viewer] set working_place=@working_place_name,working_place_description=@wokring_place_description,working_place_type=@working_place_type where id=@user_id
update [contributor] set specialization=@specilization,portofolio_link=@portofolio_link,years_of_experience=@years_experience where id=@user_id
update [Staff] set Hire_date=@hire_date,working_hours=@working_hours,payment_rate=@payment_rate where id=@user_id
go
--page 3 numberr 4 sets deactivate column =1
create procedure Deactivate_Profile @user_id int
as 
update [user] set deactivate=1 where id= @user_id;
go
--page 3 number 5 shows event outer joined ith links tables as to get all events who do not have links as well as all events that do have links
create procedure Show_Event @event_id int
as
if exists (select * from [event] where id=@event_id)
select [event].*,Event_videos_link.link as video_link,Event_photos_link.link as photo_link,[user].first_name
,[user].middle_name,[user].last_name from [user],[event] left outer join Event_photos_link  on event_photos_link.event_id=@event_id
left outer join Event_videos_link
on event_videos_link.event_id=@event_id  where [User].id=[event].viewer_id and [event].id=@event_id
else
select [event].*,Event_videos_link.link as video_link,Event_photos_link.link as photo_link,[user].first_name
,[user].middle_name,[user].last_name from [user],[event] left outer join Event_photos_link  on event_photos_link.event_id=@event_id
left outer join Event_videos_link
on event_videos_link.event_id=@event_id  where [User].id=[event].viewer_id
go
--page 3 number 6 shows notifications and adjusts seen at attribute to current time 
create procedure Show_Notification @user_id int
as
declare 
@temp_id int
if exists (select * from Staff where id=@user_id)
select @temp_id=notified_id from Staff where id=@user_id
else
if exists (select * from Contributor where id=@user_id)
begin
select @temp_id=notified_id from Contributor where id=@user_id
end
declare @object_id int
select * from Announcement left outer join [event] on Announcement.notification_object_id=[event].notif_obj_id left outer join [new_request] on
Announcement.notification_object_id=[new_request].notif_obj_id where Announcement.notified_person_id=@temp_id;
update announcement set seen_at=CURRENT_TIMESTAMP where notified_person_id=@temp_id;
go

--page 3 number 7 searches for new content that i ordered
create procedure Show_New_Content @viewer_id int, @content_id int
as
if
@content_id is not null
select New_content.*,content.*,[user].first_name,[User].middle_name,[User].last_name from new_request,content,New_content,[User] where
New_content.new_request_id=new_request.id and new_request.viewer_id=@viewer_id and New_content.id=@content_id and content.id=New_content.id and [user].id=content.contributer_id
else
select New_content.*,content.*,[user].first_name,[User].middle_name,[User].last_name from new_request,content,New_content,[User] where
New_content.new_request_id=new_request.id and new_request.viewer_id=@viewer_id  and content.id=New_content.id and [user].id=content.contributer_id
go
--page 3 number 1 allows a viewer to create an event and notifies all notified persons
create procedure Viewer_Create_Event @city varchar (max), @event_date_time datetime, @description varchar (max), @entertainer varchar (max), @viewer_id int, @location varchar (max), @event_id int OUTPUT
as
insert into notification_object default values;
insert into event values (@description,@location,@city,@event_date_time,@entertainer,scope_identity(),@viewer_id);
set @event_id=SCOPE_IDENTITY();
insert into Announcement (notification_object_id,notified_person_id)  (select [event].notif_obj_id,Notified_Person.id from [event] cross join Notified_Person where [event].id=@event_id)
update Announcement set sent_at=CURRENT_TIMESTAMP where announcement.notification_object_id=(select [event].notif_obj_id from [event] where [event].id=@event_id)
go
--page 3 number 2 allows user to add photo and video links to an event
create procedure Viewer_Upload_Event_Photo @event_id int, @link varchar (max)
as
if exists(select * from [event] where id=@event_id) and not exists (select * from Event_photos_link where Event_photos_link.event_id=@event_id and Event_photos_link.link=@link)
insert into Event_photos_link values (@event_id,@link)
go
create procedure Viewer_Upload_Event_Video @event_id int, @link varchar (max)
as
if exists(select * from [event] where id=@event_id) and not exists (select * from Event_videos_link where Event_videos_link.event_id=@event_id and Event_videos_link.link=@link)
insert into Event_videos_link values (@event_id,@link)
go
--page 3 number 3 makes viewer create an advertisement from an event by selecting all necessary data from event table
create procedure Viewer_Create_Ad_From_Event @event_id int
as
if exists (select * from [event] where id=@event_id)
insert into advertisement values ((select [event].[description] from [event] where [event].id=@event_id),(select [event].[location] from [event] where [event].id=@event_id),@event_id,
(select [event].[viewer_id] from [event] where [event].id=@event_id));
go
--page 3 number 4 makes a viewer apply to buy original content and checks if rating is atleast 4
create procedure Apply_Existing_Request @viewer_id int,@original_content_id int
as
if exists (select * from Original_content where Original_content.id=@original_content_id and rating >=4) and exists (select * from Viewer where id=@viewer_id)
insert into existing_Request values (@original_content_id,@viewer_id);
go
--page 3 number 5 makes a viewer make a new_request and can specify a contributor in this case specified bit is equal to 1 and notifies all contributors if not specified,
--otherwise only the specified contributor will be notified by creating announcements
create procedure Apply_New_Request @information varchar (max), @contributor_id int, @viewer_id int
as
if exists (select * from Contributor where id=@contributor_id) and exists (select * from Viewer where id=@viewer_id)
begin
declare @temp_id int;
insert into notification_object default values;
set @temp_id=SCOPE_IDENTITY();
if (@contributor_id is null)
begin
insert into new_request (specified,information,viewer_id,notif_obj_id) values (0,@information,@viewer_id,@temp_id);
insert into Announcement (notification_object_id,notified_person_id)  (select new_request.notif_obj_id,Contributor.notified_id from [new_request] cross join Contributor where new_request.specified=0 and new_request.id=SCOPE_IDENTITY());
update Announcement set sent_at=CURRENT_TIMESTAMP where notification_object_id=@temp_id
end
else 
begin
insert into new_request (specified,information,viewer_id,notif_obj_id,contributer_id) values (1,@information,@viewer_id,@temp_id,@contributor_id);
insert into Announcement (notification_object_id,notified_person_id) values (@temp_id,(select Contributor.notified_id from Contributor where Contributor.id=@contributor_id));
update Announcement set sent_at=CURRENT_TIMESTAMP where notification_object_id=@temp_id;
end
end
go
--page 4 number 6 delete a non accepted new_request
create procedure Delete_New_Request @request_id int
as 
delete new_request where new_request.id=@request_id and (accept_status=0 or accept_status is null);
go
--page 4 number 7 viewer reates original content
create procedure Rating_Original_Content @orignal_content_id int, @rating_value float, @viewer_id int
as
if exists (select * from Original_content where id=@orignal_content_id) and exists (select * from Viewer where id=@viewer_id)
insert into Rate (viewer_id,original_content_id,Rate,[date]) values (@viewer_id,@orignal_content_id,@rating_value,CURRENT_TIMESTAMP);
go
--page 4 number 8 inserts a comment in comment table
create procedure Write_Comment  @comment_text varchar(max), @viewer_id int, @original_content_id int, @written_time datetime
as
if exists(select * from Original_content where id=@original_content_id) and exists (select * from Viewer where id=@viewer_id)
and not exists (select * from Comment where viewer_id=@viewer_id and original_content_id=@original_content_id and [date]=@written_time)
insert into Comment (viewer_id,original_content_id,[date],[text]) values (@viewer_id,@original_content_id,@written_time,@comment_text);
go
--page 4 number 9 edits existing comment and updates date
create procedure Edit_Comment @comment_text varchar(max), @viewer_id int, @original_content_id int, @last_written_time datetime, @updated_written_time datetime
as
update Comment set [text]=@comment_text,[date]=@updated_written_time where viewer_id=@viewer_id and original_content_id=@original_content_id and [date]=@last_written_time
go
--page 4 number 10 deletes a comment
create procedure Delete_Comment @viewer_id int, @original_content_id int,@written_time datetime
as
delete Comment where viewer_id=@viewer_id and original_content_id=@original_content_id and [date]=@written_time;
go
--page 4 number 11 viewer creates an advertisement with data provided
create procedure Create_Ads @viewer_id int,@description varchar(max), @location varchar (max)
as
if exists (select * from Viewer where id=@viewer_id)
insert into advertisement ([description],[location],viewer_id) values (@description,@location,@viewer_id);
go


--Viewer User Story #12
create procedure Edit_Ad
@ad_id int,
@description varchar(max),
@location varchar(500)
as
if exists(select * from advertisement where id=@ad_id)
begin
update advertisement 
set [description]=@description, [location]=@location
where id=@ad_id
end
else
print('This advertisement does not exist')
go

--Viewer User Story #13
create procedure Delete_Ads
@ad_id int 
as
if exists(select * from advertisement where id=@ad_id)
Delete from advertisement where id=@ad_id
else
print('This advertisement does not exist')
go

--Viewer User Story #14
create procedure Send_Message
@msg_text varchar(max),
@viewer_id int,
@contributor_id int,
@sender_type bit,
@sent_at datetime
as
if exists(select * from [Message] where sent_at=@sent_at and viewer_id=@viewer_id and contributer_id=@contributor_id and sender_type=@sender_type)
print('This message already exists')
else
begin
if exists(select * from contributor where id=@contributor_id) and exists(select * from viewer where id=@viewer_id)
insert into [Message] (sent_at, contributer_id, viewer_id, sender_type, message_text)
values (@sent_at, @contributor_id, @viewer_id, @sender_type, @msg_text)
else
print('You cannot send this message')
end
go

--Viewer User Story #15
create procedure Show_Message
@contributor_id int
as
if exists(select * from contributor where id=@contributor_id)
select * from [Message] where contributer_id=@contributor_id
else
print('This contributer does not exist')
go

--Viewer User Story #16
create procedure Highest_Rating_Original_content
as
select max(rating) as rating
into Temp_rating 
from Original_content
Select OC.*
from Original_content OC
	inner join Temp_rating T on OC.rating=T.rating
drop table Temp_rating
go
--Viewer User Story #17
create procedure Assign_New_Request
@request_id int,
@contributor_id int
as
if exists(select * from Contributor where id=@contributor_id) and exists(select * from new_request where id=@request_id)
begin
declare @accepted int
select @accepted=accept_status from new_request where id=@request_id
if @accepted=0
print('This request is rejected, you cannot reapply')
else
begin
if @accepted=1
print('This request is already accepted, you cannot reassign')
else
update new_request set contributer_id=@contributor_id, specified=1 where id=@request_id
end
end
else
print('This request or contributer does not exist')
go

--Contributer User Story #1
create procedure Receive_New_Requests
@request_id int,
@contributor_id int
as
if exists(select * from contributor where id=@contributor_id)
begin
if @request_id is null
select * from new_request where (specified=0) or (specified=1 and contributer_id=@contributor_id)
else
begin
if exists(select * from new_request where id=@request_id)
begin
declare @temp_specified int, @temp_cont int
select @temp_specified=specified, @temp_cont=contributer_id from new_request where id=@request_id
if @temp_specified=1 and @temp_cont<>@contributor_id
print('This request is specified to another contributer')
else
select * from new_request where id=@request_id
end
else
print('This request does not exist')
end
end
else
print('This contributer does not exist')
go
--Contributer User Story #2
create procedure Respond_New_Request 
@contributor_id int,
@accept_status bit,
@request_id int
as
if exists(select * from contributor where id=@contributor_id) and exists(select * from new_request where id=@request_id)
begin
declare @accepted bit
select @accepted=accept_status from new_request where id=@request_id
if @accepted=1
print('This request is already accepted')
if @accepted=0
print('This request is already rejected')
if @accepted is null
begin
declare @temp_specified bit, @temp_cont int
select @temp_specified=specified, @temp_cont=contributer_id from new_request where id=@request_id
if @temp_specified=1 and @temp_cont<>@contributor_id
print('This request has another specified contributer')
else
begin
if @temp_specified=0 and @accept_status=0
print('You cannot reject a request with no specified contributer')
else
begin
update new_request set accept_status=@accept_status, contributer_id=@contributor_id,specified=1  where id=@request_id
if @accept_status=1
update new_request set accepted_at=CURRENT_TIMESTAMP where id=@request_id
end
end
end
end
else
print('This contributer or request does not exist')
go
--Contributer User Story #3
create procedure Upload_Original_Content
@type_id varchar(50),
@subcategory_name varchar(50),
@category_id varchar(50),
@contributor_id int,
@link varchar(200)
as
insert into content ([type], subcategory_name, category_type, contributer_id, link)
values (@type_id, @subcategory_name, @category_id, @contributor_id, @link)
insert into Original_content (id) values (SCOPE_IDENTITY())
go

--Contributer User Story #4
create procedure Upload_New_Content
@type_id varchar(50),
@new_request_id int,
@contributor_id int,
@subcategory_name varchar(50),
@category_id varchar(50),
@link varchar(200)
as
if exists (select * from new_request where new_request.id=@new_request_id and new_request.contributer_id=@contributor_id) and not exists
(select * from new_request,New_content where New_content.new_request_id=new_request.id)
begin
insert into content ([type], subcategory_name, category_type, contributer_id, link)
values (@type_id,@subcategory_name, @category_id, @contributor_id, @link)
declare @temp_id int
select @temp_id=SCOPE_IDENTITY() from content
insert into New_content (id, new_request_id) values (@temp_id, @new_request_id)
end
go

--Contributer User Story #5
create procedure Delete_Content
@content_id int
as
if exists(select * from new_content where id=@content_id)
begin
delete from new_content where id=@content_id
delete from content where id=@content_id
end
else
begin
if exists(select * from Original_content where id=@content_id)
begin
declare @temp_review bit
select @temp_review=review_status from Original_content where id=@content_id
if @temp_review=0 or @temp_review is null
begin
delete from Original_content where id=@content_id
delete from content where id=@content_id
end
else
print('You cannot delete as filtering process started')
end
else
print('This content does not exist')
end
go

--Contributer User Story #6
create procedure Receive_New_Request
@contributor_id int,
@can_receive bit OUTPUT
as
if exists(select * from Contributor where id=@contributor_id)
begin
select * into temp_new_request from new_request where contributer_id=@contributor_id and accept_status=1
declare @total_requests int, @total_uploaded int
select @total_requests=count(*) from temp_new_request
select @total_uploaded=count(T.id)
from temp_new_request T
	left outer join New_content N on N.new_request_id=T.id
drop table temp_new_request
if (@total_requests-@total_uploaded<3)
set @can_receive = 1
else
set @can_receive = 0
end
else
print('This contributer does not exist')
go

--Staff User Story #1
create procedure reviewer_filter_content
@reviewer_id int,
@original_content int, 
@status bit
as
if exists(select * from Reviewer where id=@reviewer_id) and exists(select * from Original_content where id=@original_content)
update Original_content 
set reviewer_id=@reviewer_id, review_status=@status
where id=@original_content
else
print('Reviewer or Original content does not exist')
go

--Staff User Story #2
create procedure content_manager_filter_content
@content_manager_id int,
@original_content int,
@status bit
as
if exists(select * from Content_manager where id=@content_manager_id) and exists(select * from Original_content where id=@original_content)
begin
declare @type_check_content varchar(50), @type_check_manager varchar(50)
select @type_check_content=[type] from content where id=@original_content
select @type_check_manager=[type] from Content_manager where id=@content_manager_id
if @type_check_content<>@type_check_manager
print('Type of content manager is not the same as original content')
else
begin
declare @review bit
select @review=review_status from Original_content where id=@original_content
if @review<>1
print('The content is not reviewed by an authorized reviewer yet')
else
update Original_content 
set content_manager_id=@content_manager_id, filter_status=@status
where id=@original_content
end
end
else
print('Content manager or Original content does not exist')
go

--Staff User Story #3
create  procedure Staff_Create_Category
@category_name varchar(50)
as
if exists(select * from Category where [type]=@category_name)
print('This category already exists')
else
insert into Category ([type]) values (@category_name)
go

--Staff User Story #4
create procedure Staff_Create_Subcategory
@category_name varchar(50),
@subcategory_name varchar(50)
as
if exists(select * from sub_category where category_type=@category_name and [name]=@subcategory_name)
print('This subcategory already exists')
else
begin
if exists(select * from Category where [type]=@category_name)
insert into sub_category values (@category_name, @subcategory_name)
else
print('This category does not exist')
end
go
 
--Staff User Story #5
create procedure Staff_Create_Type
@type_name varchar(50)
as
if exists(select * from Content_type where [type]=@type_name)
print('This type already exists')
else
insert into Content_type values (@type_name)
go

--Staff User Story #6
create procedure Most_Requested_Content
as
select oc.id, count(er.id) AS ReqCount
into temp
from Original_content oc
	inner join existing_Request er on oc.id=er.original_content_id
group by oc.id
order by count(er.id) desc
select *
from temp t
	inner join content c on t.id = c.id
	inner join [user] u on u.id = c.contributer_id
	inner join Original_content o on o.id = t.id
drop table temp
go

--Staff User Story #7
create procedure Workingplace_Category_Relation
as
select v.working_place_type, c.category_type, count(nr.id)+count(er.id)
from content c 
	left outer join Original_content oc on c.id=oc.id
	left outer join New_content nc on c.id=nc.id
	left outer join new_request nr on nc.new_request_id=nr.id
	left outer join existing_Request er on er.original_content_id=oc.id
	left outer join Viewer v on (v.id=nr.viewer_id or v.id=er.viewer_id)
where v.working_place_type is not null
group by v.working_place_type,c.category_type
go

--Staff User Story #8
create procedure Delete_Comment2
@viewer_id int,
@original_content_id int, 
@comment_time datetime
as
if exists(select * from Comment where viewer_id=@viewer_id and original_content_id=@original_content_id and [date]=@comment_time)
delete from Comment where viewer_id=@viewer_id and original_content_id=@original_content_id and [date]=@comment_time
else
print('This comment does not exist')
go

--Staff User Story #9
create procedure Delete_Original_Content
@content_id int
as
if exists(select * from Original_content where id=@content_id)
delete from Original_content where id=@content_id
else
print('This content does not exist')
go

--Staff User Story #10
create procedure Delete_New_Content
@content_id int
as
if exists(select * from New_content where id=@content_id)
delete from New_content where id=@content_id
else
print('This content does not exist')
go

--Staff User Story #11
create procedure Assign_Contributor_Request
@contributor_id int,
@new_request_id int
as
if exists(select * from Contributor where id=@contributor_id) and exists(select * from new_request where id=@new_request_id)
begin
declare @temp_specified bit, @temp_cont int
select @temp_specified=specified, @temp_cont=contributer_id from new_request where id=@new_request_id
if (@temp_specified=0) and (@temp_cont is null)
update new_request set contributer_id=@contributor_id, specified=1 where id=@new_request_id
else
print('A contributer is already assigned')
end
else
print('This request or contributer does not exist')
go

--Staff User Story #12
--we get IDs of contributors that have less than 3 open requests, then we join these IDs with  handled request and their content to get difference between accepted at and uploaded at
--then we count the handled requests
create procedure Show_Possible_Contributors
as
select a.id,count(distinct b.id) as 'the number of new requests' from (select id from Contributor except (select Contributor.id from Contributor inner join (select new_request.id,new_request.contributer_id from new_request except (select 
new_request.id,new_request.contributer_id from new_request inner join  New_content on New_content.new_request_id=new_request.id)) as [E]
on Contributor.id=e.contributer_id group by Contributor.id having count(e.id)>=3)) as A left outer join (select datediff(minute, new_request.accepted_at, content.uploaded_at) as diff,content.contributer_id
from content,new_request,New_content where content.contributer_id=new_request.contributer_id and New_content.id=content.id and New_content.new_request_id=new_request.id) as c on a.id=c.contributer_id left outer join 
(select new_request.id,new_request.contributer_id from new_request inner join  New_content on New_content.new_request_id=new_request.id) as b on b.contributer_id=a.id  group by 
a.id ORDER BY CASE WHEN avg(diff) IS NULL THEN 1 ELSE 0 END, avg(diff),count(distinct b.id) desc;

exec Show_Notification 9