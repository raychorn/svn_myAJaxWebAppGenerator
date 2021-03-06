USE [CMS]
GO
/****** Object:  Table [dbo].[objects]    Script Date: 12/05/2005 21:15:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[objects]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[objects](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[objectClassID] [int] NOT NULL,
	[objectName] [varchar](7000) NULL,
	[publishedVersion] [int] NOT NULL,
	[editVersion] [int] NOT NULL,
	[created] [smalldatetime] NOT NULL,
	[createdBy] [varchar](50) NULL,
	[updated] [smalldatetime] NOT NULL,
	[updatedBy] [varchar](50) NULL,
 CONSTRAINT [PK_objects] PRIMARY KEY CLUSTERED 
(
	[id] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[objectClassDefinitions]    Script Date: 12/05/2005 21:15:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[objectClassDefinitions]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[objectClassDefinitions](
	[objectClassID] [int] IDENTITY(1,1) NOT NULL,
	[className] [varchar](50) NOT NULL,
	[classPath] [varchar](7000) NOT NULL,
 CONSTRAINT [PK_objectClassDefinitions] PRIMARY KEY CLUSTERED 
(
	[className] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[objectAttributes]    Script Date: 12/05/2005 21:15:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[objectAttributes]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[objectAttributes](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[objectID] [int] NOT NULL,
	[attributeName] [varchar](50) NOT NULL,
	[valueString] [varchar](7000) NULL,
	[valueText] [text] NULL,
	[displayOrder] [int] NOT NULL,
	[startVersion] [int] NOT NULL,
	[lastVersion] [int] NOT NULL,
	[created] [smalldatetime] NOT NULL,
	[createdBy] [varchar](50) NULL,
	[updated] [smalldatetime] NOT NULL,
	[updatedBy] [varchar](50) NULL,
 CONSTRAINT [PK_objectAttributes] PRIMARY KEY CLUSTERED 
(
	[id] ASC
) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[objectLinks]    Script Date: 12/05/2005 21:15:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[objectLinks]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[objectLinks](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[ownerId] [int] NOT NULL,
	[relatedId] [int] NOT NULL,
	[ownerPropertyName] [varchar](50) NULL,
	[relatedPropertyName] [varchar](50) NULL,
	[ownerAutoload] [int] NOT NULL,
	[relatedAutoload] [int] NOT NULL,
	[displayOrder] [int] NOT NULL,
	[startVersion] [int] NOT NULL,
	[lastVersion] [int] NOT NULL,
	[created] [smalldatetime] NOT NULL,
	[createdBy] [varchar](50) NULL,
	[updated] [smalldatetime] NOT NULL,
	[updatedBy] [varchar](50) NULL,
 CONSTRAINT [PK_objectLinks] PRIMARY KEY CLUSTERED 
(
	[id] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
USE [CMS]
GO
USE [CMS]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_objectAttributes_objects]') AND type = 'F')
ALTER TABLE [dbo].[objectAttributes]  WITH NOCHECK ADD  CONSTRAINT [FK_objectAttributes_objects] FOREIGN KEY([objectID])
REFERENCES [dbo].[objects] ([id])
GO
ALTER TABLE [dbo].[objectAttributes] CHECK CONSTRAINT [FK_objectAttributes_objects]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_objectLinks_objects]') AND type = 'F')
ALTER TABLE [dbo].[objectLinks]  WITH NOCHECK ADD  CONSTRAINT [FK_objectLinks_objects] FOREIGN KEY([ownerId])
REFERENCES [dbo].[objects] ([id])
GO
ALTER TABLE [dbo].[objectLinks] CHECK CONSTRAINT [FK_objectLinks_objects]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_objectLinks_objects1]') AND type = 'F')
ALTER TABLE [dbo].[objectLinks]  WITH NOCHECK ADD  CONSTRAINT [FK_objectLinks_objects1] FOREIGN KEY([relatedId])
REFERENCES [dbo].[objects] ([id])
GO
ALTER TABLE [dbo].[objectLinks] CHECK CONSTRAINT [FK_objectLinks_objects1]
