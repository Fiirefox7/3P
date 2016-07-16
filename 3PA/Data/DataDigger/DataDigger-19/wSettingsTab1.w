&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER phParent    AS HANDLE      NO-UNDO.
DEFINE INPUT  PARAMETER phRectangle AS HANDLE      NO-UNDO.

/* Local Variable Definitions ---                                       */

{ DataDigger.i }

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-1 FRAME-S FRAME-I 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnClearCache 
     LABEL "Clear Cache" 
     SIZE-PIXELS 75 BY 24 TOOLTIP "clear all objects from the cache".

DEFINE VARIABLE fiPreCacheInterval AS INTEGER FORMAT ">>>,>>9":U INITIAL 0 
     LABEL "Interval" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 30 BY 21 NO-UNDO.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE-PIXELS 330 BY 85.

DEFINE VARIABLE tgCacheFieldDefs AS LOGICAL INITIAL no 
     LABEL "Field Definitions" 
     VIEW-AS TOGGLE-BOX
     SIZE-PIXELS 140 BY 17 TOOLTIP "cache table definitions" NO-UNDO.

DEFINE VARIABLE tgCacheTableDefs AS LOGICAL INITIAL no 
     LABEL "Table Definitions" 
     VIEW-AS TOGGLE-BOX
     SIZE-PIXELS 115 BY 17 TOOLTIP "cache table definitions" NO-UNDO.

DEFINE VARIABLE tgCacheUserSettings AS LOGICAL INITIAL no 
     LABEL "Cache User Settings" 
     VIEW-AS TOGGLE-BOX
     SIZE-PIXELS 150 BY 17 TOOLTIP "cache user settings" NO-UNDO.

DEFINE VARIABLE tgPreCache AS LOGICAL INITIAL no 
     LABEL "Background Pre-Caching" 
     VIEW-AS TOGGLE-BOX
     SIZE-PIXELS 155 BY 17 TOOLTIP "use pre-caching for tables and fields" NO-UNDO.

DEFINE VARIABLE fiMaxFilterHistory AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Maximum nr data filter history to save" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 30 BY 21 NO-UNDO.

DEFINE VARIABLE tgAutoExpandQueryEditor AS LOGICAL INITIAL no 
     LABEL "Auto &Expand Query Editor After Right Click On Index" 
     VIEW-AS TOGGLE-BOX
     SIZE-PIXELS 270 BY 17 NO-UNDO.

DEFINE VARIABLE tgShowHiddenTables AS LOGICAL INITIAL no 
     LABEL "Show &Hidden Tables In Table Browse" 
     VIEW-AS TOGGLE-BOX
     SIZE-PIXELS 215 BY 17 NO-UNDO.

DEFINE VARIABLE fiMaxColumns AS INTEGER FORMAT ">,>>>,>>9":U INITIAL 0 
     LABEL "Maximum nr of &columns in Data Browse" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 30 BY 21 NO-UNDO.

DEFINE VARIABLE fiMaxQueryHistory AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Maximum nr of &queries to save" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 30 BY 21 NO-UNDO.

DEFINE VARIABLE fiQueryTimeOut AS INTEGER FORMAT ">,>>>,>>9":U INITIAL 0 
     LABEL "Query time out" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 30 BY 21 NO-UNDO.

DEFINE VARIABLE cbDoubleClick AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Double click on data record will" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "DUMP","EDIT","VIEW" 
     DROP-DOWN-LIST
     SIZE-PIXELS 70 BY 21 TOOLTIP "what to do when you double click on a record in the data browse" NO-UNDO.

DEFINE VARIABLE cbViewType AS CHARACTER FORMAT "X(256)":U 
     LABEL "Default &View type" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "TXT","HTML","XLS","4GL" 
     DROP-DOWN-LIST
     SIZE-PIXELS 70 BY 21 TOOLTIP "the format for viewing data" NO-UNDO.

DEFINE VARIABLE tgKeepAlive AS LOGICAL INITIAL no 
     LABEL "&Keep DB Connections Alive" 
     VIEW-AS TOGGLE-BOX
     SIZE-PIXELS 170 BY 17 TOOLTIP "poll every 5 minutes on each DB to ensure the connection stays alive" NO-UNDO.

DEFINE VARIABLE tgStartOnPrimaryMonitor AS LOGICAL INITIAL no 
     LABEL "&Always start on primary monitor" 
     VIEW-AS TOGGLE-BOX
     SIZE-PIXELS 170 BY 17 TOOLTIP "if you have more than 1 monitor forces DD to start on primary" NO-UNDO.

DEFINE VARIABLE tgUseDeleteTriggers AS LOGICAL INITIAL no 
     LABEL "Use &Delete triggers" 
     VIEW-AS TOGGLE-BOX
     SIZE-PIXELS 135 BY 17 TOOLTIP "enable or disable DELETE triggers when deleting records" NO-UNDO.

DEFINE VARIABLE tgUseWriteTriggers AS LOGICAL INITIAL no 
     LABEL "Use &Write triggers" 
     VIEW-AS TOGGLE-BOX
     SIZE-PIXELS 135 BY 17 TOOLTIP "enable or disable WRITE triggers when editing/creating records" NO-UNDO.

DEFINE VARIABLE fiMaxExtent AS INTEGER FORMAT ">,>>>,>>9":U INITIAL 0 
     LABEL "Maximum nr of &extent fields to show" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 30 BY 21 NO-UNDO.

DEFINE BUTTON btnCheckNow 
     LABEL "Check Now" 
     SIZE-PIXELS 80 BY 24 TOOLTIP "check on the latest version of DataDigger".

DEFINE VARIABLE cbCheckForNewVersion AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "&Check" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Never",0,
                     "Daily",1,
                     "Weekly",2,
                     "Monthly",3
     DROP-DOWN-LIST
     SIZE-PIXELS 80 BY 21 TOOLTIP "set how often DataDigger should check on newer versions" NO-UNDO.

DEFINE VARIABLE cbUpdateChannel AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Channel" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Stable",0,
                     "Beta",1
     DROP-DOWN-LIST
     SIZE-PIXELS 70 BY 21 TOOLTIP "updates to normal versions or to bleeding edge beta" NO-UNDO.

DEFINE VARIABLE fiCurrentBuild AS CHARACTER FORMAT "X(256)":U 
     LABEL "Build" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 80 BY 21 NO-UNDO.

DEFINE VARIABLE fiCurrentVersion AS CHARACTER FORMAT "X(256)":U 
     LABEL "Current Version" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 25 BY 21 NO-UNDO.

DEFINE VARIABLE fiLastcheck AS CHARACTER FORMAT "X(16)":U 
     LABEL "Last check" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 100 BY 21 NO-UNDO.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE-PIXELS 325 BY 88.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT X 0 Y 0
         SIZE-PIXELS 767 BY 968 WIDGET-ID 100.

DEFINE FRAME FRAME-Y
     fiMaxExtent AT Y 0 X 200 COLON-ALIGNED WIDGET-ID 62
     "(0=show all)" VIEW-AS TEXT
          SIZE-PIXELS 85 BY 13 AT Y 5 X 245 WIDGET-ID 100
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT X 10 Y 785
         SIZE-PIXELS 340 BY 45
         TITLE "1" WIDGET-ID 3400.

DEFINE FRAME FRAME-AB
     tgCacheTableDefs AT Y 25 X 25 WIDGET-ID 188
     btnClearCache AT Y 25 X 250 WIDGET-ID 200
     tgCacheFieldDefs AT Y 45 X 25 WIDGET-ID 196
     fiPreCacheInterval AT Y 63 X 240 COLON-ALIGNED WIDGET-ID 66
     tgPreCache AT Y 65 X 25 WIDGET-ID 198
     tgCacheUserSettings AT Y 95 X 25 WIDGET-ID 192
     "Table and Field Caching" VIEW-AS TEXT
          SIZE-PIXELS 125 BY 13 AT Y 0 X 15 WIDGET-ID 184
     "sec" VIEW-AS TEXT
          SIZE-PIXELS 35 BY 13 AT Y 67 X 285 WIDGET-ID 100
     RECT-21 AT Y 5 X 5 WIDGET-ID 102
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT X 10 Y 410
         SIZE-PIXELS 400 BY 160
         TITLE "1" WIDGET-ID 3300.

DEFINE FRAME FRAME-W
     tgUseWriteTriggers AT Y 0 X 160 WIDGET-ID 96
     tgUseDeleteTriggers AT Y 1 X 10 WIDGET-ID 94
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT X 10 Y 630
         SIZE-PIXELS 340 BY 42
         TITLE "1" WIDGET-ID 3200.

DEFINE FRAME FRAME-U
     tgKeepAlive AT Y 1 X 10 WIDGET-ID 94
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT X 10 Y 350
         SIZE-PIXELS 340 BY 42
         TITLE "1" WIDGET-ID 3000.

DEFINE FRAME frUpdate
     fiCurrentVersion AT Y 15 X 86 COLON-ALIGNED WIDGET-ID 188
     fiCurrentBuild AT Y 15 X 227 COLON-ALIGNED WIDGET-ID 186
     cbUpdateChannel AT Y 40 X 86 COLON-ALIGNED WIDGET-ID 190
     cbCheckForNewVersion AT Y 40 X 227 COLON-ALIGNED WIDGET-ID 104
     btnCheckNow AT Y 65 X 237 WIDGET-ID 180
     fiLastcheck AT Y 66 X 86 COLON-ALIGNED WIDGET-ID 192
     "Auto Update" VIEW-AS TEXT
          SIZE-PIXELS 70 BY 13 AT Y 0 X 15 WIDGET-ID 184
     RECT-19 AT Y 7 X 5 WIDGET-ID 176
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT X 10 Y 220
         SIZE-PIXELS 340 BY 121
         TITLE "1" WIDGET-ID 2900.

DEFINE FRAME FRAME-D
     tgAutoExpandQueryEditor AT Y 0 X 10 WIDGET-ID 64
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT X 10 Y 0
         SIZE-PIXELS 340 BY 40
         TITLE "1" WIDGET-ID 600.

DEFINE FRAME FRAME-E
     tgShowHiddenTables AT Y 0 X 10 WIDGET-ID 68
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT X 10 Y 50
         SIZE-PIXELS 340 BY 40
         TITLE "1" WIDGET-ID 700.

DEFINE FRAME FRAME-G
     fiMaxQueryHistory AT Y 0 X 200 COLON-ALIGNED WIDGET-ID 66
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT X 10 Y 105
         SIZE-PIXELS 340 BY 45
         TITLE "1" WIDGET-ID 900.

DEFINE FRAME FRAME-H
     fiQueryTimeOut AT Y 0 X 200 COLON-ALIGNED WIDGET-ID 178
     "msec" VIEW-AS TEXT
          SIZE-PIXELS 35 BY 13 AT Y 4 X 260 WIDGET-ID 100
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT X 10 Y 165
         SIZE-PIXELS 340 BY 45
         TITLE "1" WIDGET-ID 1000.

DEFINE FRAME FRAME-C
     fiMaxFilterHistory AT Y 3 X 200 COLON-ALIGNED WIDGET-ID 66
     "(0=disable)" VIEW-AS TEXT
          SIZE-PIXELS 85 BY 13 AT Y 7 X 245 WIDGET-ID 100
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT X 10 Y 680
         SIZE-PIXELS 340 BY 55
         TITLE "1" WIDGET-ID 500.

DEFINE FRAME FRAME-F
     fiMaxColumns AT Y 0 X 200 COLON-ALIGNED WIDGET-ID 62
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT X 10 Y 740
         SIZE-PIXELS 340 BY 45
         TITLE "1" WIDGET-ID 800.

DEFINE FRAME FRAME-I
     cbDoubleClick AT Y 0 X 200 COLON-ALIGNED WIDGET-ID 92
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT X 10 Y 872
         SIZE-PIXELS 340 BY 45
         TITLE "1" WIDGET-ID 1100.

DEFINE FRAME FRAME-S
     cbViewType AT Y 0 X 200 COLON-ALIGNED WIDGET-ID 92
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT X 10 Y 830
         SIZE-PIXELS 340 BY 45
         TITLE "1" WIDGET-ID 1900.

DEFINE FRAME FRAME-V
     tgStartOnPrimaryMonitor AT Y 1 X 10 WIDGET-ID 94
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT X 10 Y 580
         SIZE-PIXELS 340 BY 42
         TITLE "1" WIDGET-ID 3100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert window title>"
         HEIGHT-P           = 980
         WIDTH-P            = 843
         MAX-HEIGHT-P       = 980
         MAX-WIDTH-P        = 843
         VIRTUAL-HEIGHT-P   = 980
         VIRTUAL-WIDTH-P    = 843
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME FRAME-AB:FRAME = FRAME DEFAULT-FRAME:HANDLE
       FRAME FRAME-C:FRAME = FRAME DEFAULT-FRAME:HANDLE
       FRAME FRAME-D:FRAME = FRAME DEFAULT-FRAME:HANDLE
       FRAME FRAME-E:FRAME = FRAME DEFAULT-FRAME:HANDLE
       FRAME FRAME-F:FRAME = FRAME DEFAULT-FRAME:HANDLE
       FRAME FRAME-G:FRAME = FRAME DEFAULT-FRAME:HANDLE
       FRAME FRAME-H:FRAME = FRAME DEFAULT-FRAME:HANDLE
       FRAME FRAME-I:FRAME = FRAME DEFAULT-FRAME:HANDLE
       FRAME FRAME-S:FRAME = FRAME DEFAULT-FRAME:HANDLE
       FRAME FRAME-U:FRAME = FRAME DEFAULT-FRAME:HANDLE
       FRAME FRAME-V:FRAME = FRAME DEFAULT-FRAME:HANDLE
       FRAME FRAME-W:FRAME = FRAME DEFAULT-FRAME:HANDLE
       FRAME FRAME-Y:FRAME = FRAME DEFAULT-FRAME:HANDLE
       FRAME frUpdate:FRAME = FRAME DEFAULT-FRAME:HANDLE.

/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */

DEFINE VARIABLE XXTABVALXX AS LOGICAL NO-UNDO.

ASSIGN XXTABVALXX = FRAME FRAME-S:MOVE-BEFORE-TAB-ITEM (FRAME FRAME-I:HANDLE)
       XXTABVALXX = FRAME FRAME-Y:MOVE-BEFORE-TAB-ITEM (FRAME FRAME-S:HANDLE)
       XXTABVALXX = FRAME FRAME-F:MOVE-BEFORE-TAB-ITEM (FRAME FRAME-Y:HANDLE)
       XXTABVALXX = FRAME FRAME-C:MOVE-BEFORE-TAB-ITEM (FRAME FRAME-F:HANDLE)
       XXTABVALXX = FRAME FRAME-W:MOVE-BEFORE-TAB-ITEM (FRAME FRAME-C:HANDLE)
       XXTABVALXX = FRAME FRAME-V:MOVE-BEFORE-TAB-ITEM (FRAME FRAME-W:HANDLE)
       XXTABVALXX = FRAME FRAME-AB:MOVE-BEFORE-TAB-ITEM (FRAME FRAME-V:HANDLE)
       XXTABVALXX = FRAME FRAME-U:MOVE-BEFORE-TAB-ITEM (FRAME FRAME-AB:HANDLE)
       XXTABVALXX = FRAME frUpdate:MOVE-BEFORE-TAB-ITEM (FRAME FRAME-U:HANDLE)
       XXTABVALXX = FRAME FRAME-H:MOVE-BEFORE-TAB-ITEM (FRAME frUpdate:HANDLE)
       XXTABVALXX = FRAME FRAME-G:MOVE-BEFORE-TAB-ITEM (FRAME FRAME-H:HANDLE)
       XXTABVALXX = FRAME FRAME-E:MOVE-BEFORE-TAB-ITEM (FRAME FRAME-G:HANDLE)
       XXTABVALXX = FRAME FRAME-D:MOVE-BEFORE-TAB-ITEM (FRAME FRAME-E:HANDLE)
/* END-ASSIGN-TABS */.

ASSIGN 
       FRAME DEFAULT-FRAME:HIDDEN           = TRUE.

/* SETTINGS FOR FRAME FRAME-AB
   NOT-VISIBLE                                                          */
ASSIGN 
       FRAME FRAME-AB:HIDDEN           = TRUE.

ASSIGN 
       fiPreCacheInterval:PRIVATE-DATA IN FRAME FRAME-AB     = 
                "DataDigger:Cache,PreCacheInterval".

ASSIGN 
       tgCacheFieldDefs:PRIVATE-DATA IN FRAME FRAME-AB     = 
                "DataDigger:Cache,FieldDefs".

ASSIGN 
       tgCacheTableDefs:PRIVATE-DATA IN FRAME FRAME-AB     = 
                "DataDigger:Cache,TableDefs".

ASSIGN 
       tgCacheUserSettings:PRIVATE-DATA IN FRAME FRAME-AB     = 
                "DataDigger:Cache,Settings".

ASSIGN 
       tgPreCache:PRIVATE-DATA IN FRAME FRAME-AB     = 
                "DataDigger:Cache,preCache".

/* SETTINGS FOR FRAME FRAME-C
   NOT-VISIBLE                                                          */
ASSIGN 
       FRAME FRAME-C:HIDDEN           = TRUE.

ASSIGN 
       fiMaxFilterHistory:PRIVATE-DATA IN FRAME FRAME-C     = 
                "DataDigger,MaxFilterHistory".

/* SETTINGS FOR FRAME FRAME-D
   NOT-VISIBLE                                                          */
ASSIGN 
       FRAME FRAME-D:HIDDEN           = TRUE.

ASSIGN 
       tgAutoExpandQueryEditor:PRIVATE-DATA IN FRAME FRAME-D     = 
                "DataDigger,AutoExpandQueryEditor".

/* SETTINGS FOR FRAME FRAME-E
   NOT-VISIBLE                                                          */
ASSIGN 
       FRAME FRAME-E:HIDDEN           = TRUE.

ASSIGN 
       tgShowHiddenTables:PRIVATE-DATA IN FRAME FRAME-E     = 
                "DataDigger,ShowHiddenTables".

/* SETTINGS FOR FRAME FRAME-F
   NOT-VISIBLE                                                          */
ASSIGN 
       FRAME FRAME-F:HIDDEN           = TRUE.

ASSIGN 
       fiMaxColumns:PRIVATE-DATA IN FRAME FRAME-F     = 
                "DataDigger,MaxColumns".

/* SETTINGS FOR FRAME FRAME-G
   NOT-VISIBLE                                                          */
ASSIGN 
       FRAME FRAME-G:HIDDEN           = TRUE.

ASSIGN 
       fiMaxQueryHistory:PRIVATE-DATA IN FRAME FRAME-G     = 
                "DataDigger,MaxQueryHistory".

/* SETTINGS FOR FRAME FRAME-H
   NOT-VISIBLE                                                          */
ASSIGN 
       FRAME FRAME-H:HIDDEN           = TRUE.

ASSIGN 
       fiQueryTimeOut:PRIVATE-DATA IN FRAME FRAME-H     = 
                "DataDigger,MaxQueryTime".

/* SETTINGS FOR FRAME FRAME-I
   NOT-VISIBLE 1                                                        */
ASSIGN 
       FRAME FRAME-I:HIDDEN           = TRUE.

ASSIGN 
       cbDoubleClick:PRIVATE-DATA IN FRAME FRAME-I     = 
                "DataDigger,DataDoubleClick".

/* SETTINGS FOR FRAME FRAME-S
   NOT-VISIBLE 1                                                        */
ASSIGN 
       FRAME FRAME-S:HIDDEN           = TRUE.

ASSIGN 
       cbViewType:PRIVATE-DATA IN FRAME FRAME-S     = 
                "DataDigger,ViewType".

/* SETTINGS FOR FRAME FRAME-U
   NOT-VISIBLE                                                          */
ASSIGN 
       FRAME FRAME-U:HIDDEN           = TRUE.

ASSIGN 
       tgKeepAlive:PRIVATE-DATA IN FRAME FRAME-U     = 
                "DataDigger,KeepAlive".

/* SETTINGS FOR FRAME FRAME-V
   NOT-VISIBLE                                                          */
ASSIGN 
       FRAME FRAME-V:HIDDEN           = TRUE.

ASSIGN 
       tgStartOnPrimaryMonitor:PRIVATE-DATA IN FRAME FRAME-V     = 
                "DataDigger,StartOnPrimaryMonitor".

/* SETTINGS FOR FRAME FRAME-W
   NOT-VISIBLE                                                          */
ASSIGN 
       FRAME FRAME-W:HIDDEN           = TRUE.

ASSIGN 
       tgUseDeleteTriggers:PRIVATE-DATA IN FRAME FRAME-W     = 
                "DataDigger,EnableDeleteTriggers".

ASSIGN 
       tgUseWriteTriggers:PRIVATE-DATA IN FRAME FRAME-W     = 
                "DataDigger,EnableWriteTriggers".

/* SETTINGS FOR FRAME FRAME-Y
   NOT-VISIBLE                                                          */
ASSIGN 
       FRAME FRAME-Y:HIDDEN           = TRUE.

ASSIGN 
       fiMaxExtent:PRIVATE-DATA IN FRAME FRAME-Y     = 
                "DataDigger,MaxExtent".

/* SETTINGS FOR FRAME frUpdate
   NOT-VISIBLE                                                          */
ASSIGN 
       FRAME frUpdate:HIDDEN           = TRUE.

ASSIGN 
       cbCheckForNewVersion:PRIVATE-DATA IN FRAME frUpdate     = 
                "DataDigger:Update,UpdateCheck".

ASSIGN 
       cbUpdateChannel:PRIVATE-DATA IN FRAME frUpdate     = 
                "DataDigger:Update,UpdateChannel".

ASSIGN 
       fiCurrentBuild:READ-ONLY IN FRAME frUpdate        = TRUE
       fiCurrentBuild:PRIVATE-DATA IN FRAME frUpdate     = 
                "DataDigger,Build".

ASSIGN 
       fiCurrentVersion:READ-ONLY IN FRAME frUpdate        = TRUE
       fiCurrentVersion:PRIVATE-DATA IN FRAME frUpdate     = 
                "DataDigger,Version".

ASSIGN 
       fiLastcheck:READ-ONLY IN FRAME frUpdate        = TRUE
       fiLastcheck:PRIVATE-DATA IN FRAME frUpdate     = 
                "DataDigger:update,UpdateLastCheck".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* <insert window title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* <insert window title> */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frUpdate
&Scoped-define SELF-NAME btnCheckNow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnCheckNow C-Win
ON CHOOSE OF btnCheckNow IN FRAME frUpdate /* Check Now */
DO:

  run btnCheckUpgrade.
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME FRAME-AB
&Scoped-define SELF-NAME btnClearCache
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnClearCache C-Win
ON CHOOSE OF btnClearCache IN FRAME FRAME-AB /* Clear Cache */
DO:
  RUN clearDiskCache.
  RUN clearRegistryCache.
  MESSAGE "Cache cleared" VIEW-AS ALERT-BOX INFO BUTTONS OK.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tgCacheTableDefs
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tgCacheTableDefs C-Win
ON VALUE-CHANGED OF tgCacheTableDefs IN FRAME FRAME-AB /* Table Definitions */
, tgCacheFieldDefs
DO:
  
  tgPreCache:SENSITIVE = (tgCacheFieldDefs:CHECKED OR tgCacheTableDefs:CHECKED).
  APPLY "VALUE-CHANGED" TO tgPreCache.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tgPreCache
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tgPreCache C-Win
ON VALUE-CHANGED OF tgPreCache IN FRAME FRAME-AB /* Background Pre-Caching */
DO:

  fiPreCacheInterval:SENSITIVE = (tgPreCache:SENSITIVE AND tgPreCache:CHECKED).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME DEFAULT-FRAME
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.


/* Handle reparenting, startup etc */
{frameLib.i}

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE btnCheckUpgrade C-Win 
PROCEDURE btnCheckUpgrade :
/*------------------------------------------------------------------------
  Name         : btnCheckUpgrade
  Description  : Check for an upgrade of DD on OE Hive
  ----------------------------------------------------------------------*/
  
  define variable iChannel          as integer   no-undo.
  define variable lUpdated          as logical   no-undo.

  iChannel = integer(cbUpdateChannel:screen-value in frame frUpdate).
  
  run getNewVersion.p
    ( input iChannel
    , input true
    , output lUpdated
    ).
    
  if lUpdated then
    message "Please restart DataDigger to proceed installation" view-as alert-box info.

end procedure. /* btnCheckUpgrade */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  VIEW FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  DISPLAY tgAutoExpandQueryEditor 
      WITH FRAME FRAME-D IN WINDOW C-Win.
  ENABLE tgAutoExpandQueryEditor 
      WITH FRAME FRAME-D IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-FRAME-D}
  DISPLAY tgShowHiddenTables 
      WITH FRAME FRAME-E IN WINDOW C-Win.
  ENABLE tgShowHiddenTables 
      WITH FRAME FRAME-E IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-FRAME-E}
  DISPLAY fiMaxQueryHistory 
      WITH FRAME FRAME-G IN WINDOW C-Win.
  ENABLE fiMaxQueryHistory 
      WITH FRAME FRAME-G IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-FRAME-G}
  DISPLAY fiQueryTimeOut 
      WITH FRAME FRAME-H IN WINDOW C-Win.
  ENABLE fiQueryTimeOut 
      WITH FRAME FRAME-H IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-FRAME-H}
  DISPLAY fiCurrentVersion fiCurrentBuild cbUpdateChannel cbCheckForNewVersion 
          fiLastcheck 
      WITH FRAME frUpdate IN WINDOW C-Win.
  ENABLE RECT-19 fiCurrentVersion fiCurrentBuild cbUpdateChannel 
         cbCheckForNewVersion btnCheckNow fiLastcheck 
      WITH FRAME frUpdate IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-frUpdate}
  DISPLAY tgKeepAlive 
      WITH FRAME FRAME-U IN WINDOW C-Win.
  ENABLE tgKeepAlive 
      WITH FRAME FRAME-U IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-FRAME-U}
  DISPLAY tgCacheTableDefs tgCacheFieldDefs fiPreCacheInterval tgPreCache 
          tgCacheUserSettings 
      WITH FRAME FRAME-AB IN WINDOW C-Win.
  ENABLE RECT-21 tgCacheTableDefs btnClearCache tgCacheFieldDefs 
         fiPreCacheInterval tgPreCache tgCacheUserSettings 
      WITH FRAME FRAME-AB IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-FRAME-AB}
  DISPLAY tgStartOnPrimaryMonitor 
      WITH FRAME FRAME-V IN WINDOW C-Win.
  ENABLE tgStartOnPrimaryMonitor 
      WITH FRAME FRAME-V IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-FRAME-V}
  DISPLAY tgUseWriteTriggers tgUseDeleteTriggers 
      WITH FRAME FRAME-W IN WINDOW C-Win.
  ENABLE tgUseWriteTriggers tgUseDeleteTriggers 
      WITH FRAME FRAME-W IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-FRAME-W}
  DISPLAY fiMaxFilterHistory 
      WITH FRAME FRAME-C IN WINDOW C-Win.
  ENABLE fiMaxFilterHistory 
      WITH FRAME FRAME-C IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-FRAME-C}
  DISPLAY fiMaxColumns 
      WITH FRAME FRAME-F IN WINDOW C-Win.
  ENABLE fiMaxColumns 
      WITH FRAME FRAME-F IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-FRAME-F}
  DISPLAY fiMaxExtent 
      WITH FRAME FRAME-Y IN WINDOW C-Win.
  ENABLE fiMaxExtent 
      WITH FRAME FRAME-Y IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-FRAME-Y}
  DISPLAY cbViewType 
      WITH FRAME FRAME-S IN WINDOW C-Win.
  ENABLE cbViewType 
      WITH FRAME FRAME-S IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-FRAME-S}
  DISPLAY cbDoubleClick 
      WITH FRAME FRAME-I IN WINDOW C-Win.
  ENABLE cbDoubleClick 
      WITH FRAME FRAME-I IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-FRAME-I}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE localInitialize C-Win 
PROCEDURE localInitialize :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  fiCurrentVersion:font in frame frUpdate = getFont("Fixed").
  fiCurrentBuild:font   in frame frUpdate = getFont("Fixed").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

