use iegypt
go
exec original_content_search @typename=null , @categoryname='music industry';
exec original_content_search @typename='soundtrack',@categoryname=null;
exec contributor_search @fullname='steven allan spielberg'
declare @out_id int
exec register_user @usertype='content manager', @email='ea@email.com', @password='sdfgeg', @firstname='foo',
@middlename='bar', @lastname='foobar', @birth_date='02/02/1990', @working_place_name='asfsdf', @working_place_type='sdfssef',
@working_place_description='sdfvsfrgv', @specilization='sdvs', @portofolio_link='sdfsdf', @years_experience=2, @hire_date='02/02/2000',
@working_hours=null, @payment_rate=null, @user_id=@out_id output
print (@out_id);
exec check_type @typename='audio', @content_manager_id=15;
exec show_original_content @contributor_id=null
go
declare @out_id int;
exec user_login @email='bob-dylan@musicians.com', @password='foreveryoung', @user_id=@out_id output
print (@out_id);
declare @user_id int, @email varchar (max) , @password varchar (max) , @firstname varchar (max) , @middlename varchar (max) ,
@lastname varchar (max) , @birth_date datetime, @working_place_name varchar (max) , @working_place_type varchar (max) , @working_place_description varchar (max) , @specilization bit ,
@portofolio_link varchar (max) , @years_experience int, @hire_date datetime , @working_hours int
, @payment_rate float
exec show_profile @user_id=90 ,@email =@email output, @password=@password output, @firstname=@firstname output, @middlename=@middlename output,
@lastname=@lastname output, @birth_date=@birth_date output, @working_place_name=@working_place_name output, @working_place_type=@working_place_type output,
@working_place_description=@working_place_description output, @specilization=@specilization output,
@portofolio_link=@portofolio_link output, @years_experience=@years_experience output, @hire_date=@hire_date output, @working_hours=@working_hours
output, @payment_rate=@payment_rate output
print(@password);
exec deactivate_profile @user_id=1;
go
exec show_event @event_id=1;
exec show_event @event_id=null;
exec show_notification @user_id=6;
exec show_new_content @viewer_id=1, @content_id=3;
go
exec show_new_content @viewer_id=1, @content_id=null;
go
declare @out int
exec viewer_create_event @city= 'cairo', @event_date_time='2018-11-13 20:12:20', @description ='testing', @entertainer= 'test entertainer', @viewer_id=1 , @location= 'egypt', @event_id=@out output
print(@out);
exec viewer_upload_event_photo @event_id=1, @link='hjvjh';
exec viewer_upload_event_video @event_id=2, @link='dhgthbg';
exec viewer_create_ad_from_event @event_id=2;
exec apply_existing_request @viewer_id=1,@original_content_id=3;
exec apply_new_request @information='testing', @contributor_id=4, @viewer_id=1; 
exec apply_new_request @information='testing', @contributor_id=null, @viewer_id=1; 
exec delete_new_request @request_id=1;
exec rating_original_content @orignal_content_id=1, @rating_value=2, @viewer_id =1
exec write_comment @comment_text='testing',@viewer_id=1,@original_content_id=6,@written_time = '2018-11-13 20:12:20';
exec edit_comment @comment_text='testing1', @viewer_id=1, @original_content_id=6, @last_written_time='2018-11-13 20:12:20', @updated_written_time='2018-11-16 20:12:20'
exec delete_comment @viewer_id=1, @original_content_id=6,@written_time='2018-11-16 20:12:20'
exec create_ads @viewer_id=1,@description='testing', @location='cairo'
exec Create_Ads '1','test description','test location';
exec Edit_Ad '3','test description 2','test location 2';
exec Delete_Ads '3';
exec Send_Message 'hi',1,4,0,'2018-11-13 22:10:22';
exec Show_Message 4;
exec Highest_Rating_Original_content;
exec Assign_New_Request 9,4;
exec Receive_New_Requests 1,6;
exec Respond_New_Request 4,0,6;
exec Upload_Original_Content 'Photograph','Rock','Music Industry',5,'www.placeholder.com';
exec Upload_New_Content 1,6,'Series','Film Industry','wwww.placeholder2.com'
exec Delete_Content 3;

declare @can_receive bit
exec Receive_New_Request 5,@can_receive output
print @can_receive

exec reviewer_filter_content 9,8,1
exec content_manager_filter_content 13,2,1
exec Staff_Create_Category 'Sports'
exec Staff_Create_Subcategory 'Film Industry','Short Movie'
exec Staff_Create_Type 'video'
exec Most_Requested_Content
exec Workingplace_Category_Relation
exec Delete_Comment 1,3,'2018-11-13 22:10:22'
exec Delete_Original_Content 3
exec Delete_New_Content 9
exec Assign_Contributor_Request 8,11
exec Show_Possible_Contributors



