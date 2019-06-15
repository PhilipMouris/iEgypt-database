use iEgypt
go
Insert into Category
values ('Film Industry','The film industry or motion picture industry, 
comprises the technological and commercial institutions of filmmaking')
Insert into Category
values ('Music Industry','The music industry consists of the companies and individuals
that earn money by creating new songsand pieces and selling live concerts and shows,
audio and video recordings')
Insert into Category
values ('Culture','The arts and other manifestations of human intellectual achievement regarded collectively.')
--
Insert into sub_category
values ((SELECT [type] from Category WHERE [type]='Film Industry'),'Documentary')
Insert into sub_category
values ((SELECT [type] from Category WHERE [type]='Film Industry'),'Feature Film')
Insert into sub_category
values ((SELECT [type] from Category WHERE [type]='Film Industry'),'Series')
Insert into sub_category
values ((SELECT [type] from Category WHERE [type]='Music Industry'),'Jazz')
Insert into sub_category
values ((SELECT [type] from Category WHERE [type]='Music Industry'),'Blues')
Insert into sub_category
values ((SELECT [type] from Category WHERE [type]='Music Industry'),'Rock')
Insert into sub_category
values ((SELECT [type] from Category WHERE [type]='Culture'),'Art')
Insert into sub_category
values ((SELECT [type] from Category WHERE [type]='Culture'),'History')
Insert into sub_category
values ((SELECT [type] from Category WHERE [type]='Culture'),'Social Impact')
--
Insert into [user]
values('scorsese@directorsunited.com', 'Martin', 'Charles', 'Scorsese',11/17/1942,'GoodFellas',0,'2018-11-13 22:10:22')
Insert into [User]
values('Tarantino@directorsunited.com','Quentin', 'Jerome', 'Tarantino',03/27/1963,'PulpFiction',0,'2018-11-13 22:10:22')
Insert into [user]
values('hitchcock@directorsunited.com','Alfred', 'Joseph', 'Hitchcock', 08/13/1901,'Psycho',0,'2018-11-13 22:10:22')
Insert into [user]
values('spielberg@directorsunited.com','Steven', 'Allan', 'Spielberg',12/18/1946,'Jaws',0,'2018-11-13 22:10:22')
Insert into [user]
values('copolla@directorsunited.com','Francis', 'Ford', 'Copolla',07/04/1939,'GodFather',0,'2018-11-13 22:10:22')
Insert into [user]
values('nolan@directorsunited.com','Christopher', 'Edward', 'Nolan',07/30/1970,'Inception',0,'2018-11-13 22:10:22')
Insert into [user]
values('Anderson@directorsunited.com','Wesley', 'Wales', 'Anderson',05/01/1969,'GrandBudapest',0,'2018-11-13 22:10:22')
Insert into [user]
values('Bob-dylan@musicians.com','Robert', 'Allen', 'Zimmerman',05/24/1941,'foreveryoung',0,'2018-11-13 22:10:22')
Insert into [user]
values('hendrix@musicians.com','James', 'Marshall', 'hendrix',11/27/1942,'thewatchtower',0,'2018-11-13 22:10:22')
Insert into [user]
values('cobain@musicians.com','kurt', 'Donald', 'Cobain',02/20/1967,'TeenSpirit',0,'2018-11-13 22:10:22')
Insert into [user]
values('winehouse@musicians.com','Amy', 'Jade', 'Winehouse',08/09/1983,'Rehab',0,'2018-11-13 22:10:22')
Insert into [user]
values('clapton@musicians.com','Eric', 'Patrick', 'Clapton',03/30/1945,'Cocaine',0,'2018-11-13 22:10:22')
Insert into [user]
values('Mercury@musicians.com','Farrokh', 'Bulsara', 'Mercury',09/05/1945,'Queen',0,'2018-11-13 22:10:22')
--
insert into Viewer
Values ((SELECT id from [User] WHERE last_name='scorsese'), 'Hollywood','studio', 
'Film industry studios and shooting places')
insert into Viewer
Values ((SELECT id from [User] WHERE last_name='Tarantino'), 'Hollywood','studio', 
'Film industry studios and shooting places')
insert into Viewer
Values ((SELECT id from [User] WHERE last_name='Hitchcock'), 'Hollywood','studio', 
'Film industry studios and shooting places')
--
Insert into Notified_Person default values;
Insert into Notified_Person default values;
Insert into Notified_Person default values;
Insert into Notified_Person default values;
Insert into Notified_Person default values;
Insert into Notified_Person default values;
Insert into Notified_Person default values;
Insert into Notified_Person default values;
Insert into Notified_Person default values;
Insert into Notified_Person default values;
Insert into Notified_Person default values;
Insert into Notified_Person default values;
Insert into Notified_Person default values;
--
insert into contributor
Values((SELECT id from [User] WHERE last_name='spielberg'),30,
'portofoliospielberg.com','film making',1)
insert into contributor
Values((SELECT id from [User] WHERE last_name='copolla'),40,
'portofoliocopolla.com','film making',2)
insert into contributor
Values((SELECT id from [User] WHERE last_name='Nolan'),15,
'portofolionolan.com','film making',3)
insert into contributor
Values((SELECT id from [User] WHERE last_name='Anderson'),13,
'portofolioanderson.com','film making',4)
insert into contributor
Values((SELECT id from [User] WHERE last_name='Zimmerman'),32,
'portofoliozimmerman.com','Music writing',5)
--
insert into Staff
values((SELECT id from [User] WHERE last_name='Hendrix'),'2001-11-19 08:00:00',
100,115.5,6)
insert into Staff
values((SELECT id from [User] WHERE last_name='Cobain'),'2001-11-19 08:00:00',
100,115.5,7)
insert into Staff
values((SELECT id from [User] WHERE last_name='Winehouse'),'2001-11-19 08:00:00',
100,115.5,8)
insert into Staff
values((SELECT id from [User] WHERE last_name='Clapton'),'2001-11-19 08:00:00',
100,115.5,9)
insert into Staff
values((SELECT id from [User] WHERE last_name='Mercury'),'2001-11-19 08:00:00',
100,115.5,10)
--
Insert into Reviewer
 Values((SELECT id from [User] WHERE last_name='Hendrix'))
 Insert into Reviewer
 Values((SELECT id from [User] WHERE last_name='Cobain'))
--
insert into content_type
Values ('Soundtrack')
insert into content_type
Values ('ShortFilm')
insert into content_type
Values ('Poster')
insert into content_type
Values ('Photograph')
--
Insert into Content_manager
Values((SELECT id from [User] WHERE last_name='Winehouse'),
(SELECT [type] from Content_type WHERE [type]='Soundtrack'))
Insert into Content_manager
Values((SELECT id from [User] WHERE last_name='Clapton'),
(SELECT [type] from Content_type WHERE [type]='Soundtrack'))
Insert into Content_manager
Values((SELECT id from [User] WHERE last_name='Mercury'),
(SELECT [type] from Content_type WHERE [type]='Poster'))
--
insert into content
values ('soundcloud.com/file21','2018-11-13 22:10:22',(SELECT [type] from Category WHERE [type] = 'Music Industry'),
(SELECT id from [User] WHERE last_name='Zimmerman'),
(SELECT [name] from sub_category WHERE [name] = 'Jazz'),(SELECT [type] from Content_type WHERE [type] = 'Soundtrack'))
--
insert into content
values ('vimeo.com/file22','2018-11-14 22:25:22',(SELECT [type] from Category WHERE [type] = 'Film Industry'),
(SELECT id from [User] WHERE last_name='Nolan'),
(SELECT [name] from sub_category WHERE [name] = 'Documentary'),
(SELECT [type] from Content_type WHERE [type] = 'Shortfilm'))
--
insert into content
values ('Behance.com/file23','2018-11-10 22:10:22',(SELECT [type] from Category WHERE [type] = 'Film Industry'),
(SELECT id from [User] WHERE last_name='Nolan'),
(SELECT [name] from sub_category WHERE [name] = 'Documentary'),
(SELECT [type] from Content_type WHERE [type] = 'Poster'))
--
insert into Original_content
Values((SELECT content.id from [content] WHERE link='soundcloud.com/file21'),
(SELECT content_manager.id from [User],Content_manager Where [User].last_name='Winehouse' and [User].id=Content_manager.id ),
(SELECT reviewer.id from [User],Reviewer WHERE [User].last_name='Hendrix' and [User].id=Reviewer.id)
,1,1,5)
--
insert into Original_content
Values((SELECT id from [content] WHERE link='vimeo.com/file22'),
(SELECT content_manager.id from [User],Content_manager Where [User].last_name='Clapton' and [User].id=Content_manager.id ),
(SELECT reviewer.id from [User],Reviewer WHERE [User].last_name='Cobain' and [User].id=Reviewer.id)
,1,1,5)
--
insert into Original_content
Values((SELECT id from [content] WHERE link='Behance.com/file23'),
(SELECT content_manager.id from [User],Content_manager Where [User].last_name='Mercury' and [User].id=Content_manager.id ),
(SELECT reviewer.id from [User],Reviewer WHERE [User].last_name='Cobain' and [User].id=Reviewer.id)
,1,1,5)
--
insert into notification_object default values;
insert into notification_object default values;
insert into notification_object default values;
insert into notification_object default values;
insert into notification_object default values;
insert into notification_object default values;
insert into notification_object default values;
insert into notification_object default values;
insert into notification_object default values;
insert into notification_object default values;
insert into notification_object default values;
insert into notification_object default values;
insert into notification_object default values;
--
Insert into new_request
values(1,1,'shortfilm', 
(select Viewer.id from Viewer,[User] where [user].last_name='scorsese' and [user].id=Viewer.id),
1,
(select contributor.id from contributor,[User] where [user].last_name='nolan' and [user].id=contributor.id),'2001-11-19 08:00:00')
--
Insert into new_request
values(1,1,'Poster', 
(select Viewer.id from Viewer,[User] where [user].last_name='Tarantino' and [user].id=Viewer.id),
2,
(select contributor.id from contributor,[User] where [user].last_name='nolan' and [user].id=contributor.id),'2001-11-20 08:00:00')
--
Insert into new_request
values(1,1,'Poster', 
(select Viewer.id from Viewer,[User] where [user].last_name='Tarantino' and [user].id=Viewer.id),
3,
(select contributor.id from contributor,[User] where [user].last_name='copolla' and [user].id=contributor.id),'2001-11-21 08:00:00')
--
Insert into new_request
values(1,1,'Photograph', 
(select Viewer.id from Viewer,[User] where [user].last_name='scorsese' and [user].id=Viewer.id),
4,
(select contributor.id from contributor,[User] where [user].last_name='copolla' and [user].id=contributor.id),'2001-11-22 08:00:00')
--
Insert into new_request
values(1,1,'History Photograph', 
(select Viewer.id from Viewer,[User] where [user].last_name='Hitchcock' and [user].id=Viewer.id),
5,
(select contributor.id from contributor,[User] where [user].last_name='copolla' and [user].id=contributor.id),'2001-11-23 08:00:00')
--
Insert into new_request
values(1,1,'none', 
(select Viewer.id from Viewer,[User] where [user].last_name='Hitchcock' and [user].id=Viewer.id),
6,
(select contributor.id from contributor,[User] where [user].last_name='spielberg' and [user].id=contributor.id),'2001-12-19 08:00:00')
--
Insert into new_request
values(1,1,'none', 
(select Viewer.id from Viewer,[User] where [user].last_name='Hitchcock' and [user].id=Viewer.id),
7,
(select contributor.id from contributor,[User] where [user].last_name='Anderson' and [user].id=contributor.id),'2002-11-19 08:00:00')
--
Insert into new_request
values(1,1,'none', 
(select Viewer.id from Viewer,[User] where [user].last_name='scorsese' and [user].id=Viewer.id),
8,
(select contributor.id from contributor,[User] where [user].last_name='Zimmerman' and [user].id=contributor.id),'2002-12-19 08:00:00')
--
Insert into new_request
values(null,0,'none', 
(select Viewer.id from Viewer,[User] where [user].last_name='Tarantino' and [user].id=Viewer.id),
9,null,null)
--
Insert into new_request
values(null,0,'none', 
(select Viewer.id from Viewer,[User] where [user].last_name='Tarantino' and [user].id=Viewer.id),
10,null,null)
--
Insert into new_request
values(null,0,'none', 
(select Viewer.id from Viewer,[User] where [user].last_name='Tarantino' and [user].id=Viewer.id),
11,null,null)
--
Insert existing_Request
Values(1,(select viewer.id from [User],Viewer where [User].last_name='scorsese' and [User].id=Viewer.id))
Insert existing_Request
Values(3,(select viewer.id from [User],Viewer where [User].last_name='Tarantino' and [User].id=Viewer.id))

Insert into [event]
values('Screening','Zawya Cinema','Cairo','2018-12-12 10:10:10','Amr Diab', 12,
(select viewer.id from [User],Viewer where [User].last_name='Tarantino' and [User].id=Viewer.id))

Insert into [event]
values('Concert','AUC','Cairo','2018-12-13 10:10:10','Bob Marley', 13,
(select viewer.id from [User],Viewer where [User].last_name='scorsese' and [User].id=Viewer.id))

Insert into advertisement
Values ('Mcdonalds','Merghany',1,
(select viewer.id from [User],Viewer where [User].last_name='scorsese' and [User].id=Viewer.id))
--
Insert into advertisement
Values ('Hyundai','90 Road',2,
(select viewer.id from [User],Viewer where [User].last_name='Tarantino' and [User].id=Viewer.id))

insert into Announcement (notification_object_id,notified_person_id)  (select [event].notif_obj_id,Notified_Person.id from [event] cross join Notified_Person)
insert into Announcement (notification_object_id,notified_person_id)  (select new_request.notif_obj_id,Contributor.notified_id from [new_request] cross join Contributor where new_request.specified=0)
insert into Announcement (notification_object_id,notified_person_id)  (select new_request.notif_obj_id,Contributor.notified_id from [new_request] inner join Contributor on new_request.contributer_id=Contributor.id where new_request.specified=1  )
update announcement set sent_at=current_timestamp ;