USE [CMS]
GO
/****** Object:  Table [dbo].[objectClassDefinitions]    Script Date: 12/05/2005 21:22:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[objectClassDefinitions]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[objectClassDefinitions](
	[objectClassID] [int] IDENTITY(1,1) NOT NULL,
	[className] [varchar](50) NOT NULL,
	[classPath] [varchar](7000) NOT NULL,
 CONSTRAINT [PK_objectClassDefinitions_1] PRIMARY KEY CLUSTERED 
(
	[className] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[objects]    Script Date: 12/05/2005 21:22:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[objects]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[objects](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[objectClassID] [int] NOT NULL,
	[objectName] [varchar](7000) NULL,
	[publishedVersion] [int] NOT NULL CONSTRAINT [DF_Objects_pub_version]  DEFAULT ((0)),
	[editVersion] [int] NOT NULL,
	[created] [smalldatetime] NOT NULL CONSTRAINT [DF_Objects_created]  DEFAULT (getdate()),
	[createdBy] [varchar](50) NULL,
	[updated] [smalldatetime] NOT NULL CONSTRAINT [DF_Objects_updated]  DEFAULT (getdate()),
	[updatedBy] [varchar](50) NULL,
 CONSTRAINT [PK_Objects] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[objectLinks]    Script Date: 12/05/2005 21:22:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[objectLinks]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[objectLinks](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[ownerId] [int] NOT NULL,
	[relatedId] [int] NOT NULL,
	[ownerPropertyName] [varchar](50) NULL,
	[relatedPropertyName] [varchar](50) NULL,
	[ownerAutoload] [int] NOT NULL CONSTRAINT [DF_objectLinks_ownerAutoload]  DEFAULT (1),
	[relatedAutoload] [int] NOT NULL CONSTRAINT [DF_objectLinks_relatedAutoload]  DEFAULT (0),
	[displayOrder] [int] NOT NULL CONSTRAINT [DF_Object_Rel_display_order]  DEFAULT (1),
	[startVersion] [int] NOT NULL,
	[lastVersion] [int] NOT NULL CONSTRAINT [DF_objectLinks_lastVersion]  DEFAULT (2147483647),
	[created] [smalldatetime] NOT NULL CONSTRAINT [DF_Object_Rel_created]  DEFAULT (getdate()),
	[createdBy] [varchar](50) NULL,
	[updated] [smalldatetime] NOT NULL CONSTRAINT [DF_Object_Rel_updated]  DEFAULT (getdate()),
	[updatedBy] [varchar](50) NULL,
 CONSTRAINT [PK_Object_Rel] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[objectAttributes]    Script Date: 12/05/2005 21:22:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[objectAttributes]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[objectAttributes](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[objectID] [int] NOT NULL,
	[attributeName] [varchar](50) NOT NULL,
	[valueString] [varchar](7000) NULL,
	[valueText] [text] NULL,
	[displayOrder] [int] NOT NULL CONSTRAINT [DF_Object_Att_display_order]  DEFAULT ((1)),
	[startVersion] [int] NOT NULL,
	[lastVersion] [int] NOT NULL CONSTRAINT [DF_Object_Att_lastVersion]  DEFAULT ((2147483647)),
	[created] [smalldatetime] NOT NULL CONSTRAINT [DF_object_att_created]  DEFAULT (getdate()),
	[createdBy] [varchar](50) NULL,
	[updated] [smalldatetime] NOT NULL CONSTRAINT [DF_Object_Att_updated]  DEFAULT (getdate()),
	[updatedBy] [varchar](50) NULL,
 CONSTRAINT [PK_object_att] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
USE [CMS]
GO
USE [CMS]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_objectLinks_objects]') AND parent_object_id = OBJECT_ID(N'[dbo].[objectLinks]'))
ALTER TABLE [dbo].[objectLinks]  WITH NOCHECK ADD  CONSTRAINT [FK_objectLinks_objects] FOREIGN KEY([ownerId])
REFERENCES [dbo].[objects] ([id])
GO
ALTER TABLE [dbo].[objectLinks] CHECK CONSTRAINT [FK_objectLinks_objects]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_objectLinks_objects1]') AND parent_object_id = OBJECT_ID(N'[dbo].[objectLinks]'))
ALTER TABLE [dbo].[objectLinks]  WITH NOCHECK ADD  CONSTRAINT [FK_objectLinks_objects1] FOREIGN KEY([relatedId])
REFERENCES [dbo].[objects] ([id])
GO
ALTER TABLE [dbo].[objectLinks] CHECK CONSTRAINT [FK_objectLinks_objects1]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Object_Att_Objects]') AND parent_object_id = OBJECT_ID(N'[dbo].[objectAttributes]'))
ALTER TABLE [dbo].[objectAttributes]  WITH NOCHECK ADD  CONSTRAINT [FK_Object_Att_Objects] FOREIGN KEY([objectID])
REFERENCES [dbo].[objects] ([id])
GO
ALTER TABLE [dbo].[objectAttributes] CHECK CONSTRAINT [FK_Object_Att_Objects]
