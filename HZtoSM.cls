VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cHztoSM"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'Download by http://www.NewXing.com
Option Explicit

Const ERR_RESULT$ = "?"          ' �����Ĵ��󷵻�ֵ

Private mGB2312SM$
Private mLoadLibSuccess As Boolean

Private Sub Class_Initialize()
    mGB2312SM$ = ""
    mLoadLibSuccess = False
End Sub

Private Sub Class_Terminate()
    mGB2312SM$ = ""
    mLoadLibSuccess = False
End Sub


'==================================================
' ���ؿ��ļ� �ɹ� LoadLibSuccess = True
'            ʧ�� LoadLibSuccess = False
Public Property Get LoadLibSuccess() As Boolean
    LoadLibSuccess = mLoadLibSuccess
End Property
'==================================================


'==================================================
' ����: LoadLibFile
'
' ����: ���ؿ��ļ�
'
' ע��: �����ü��سɹ���־ mLoadLibSuccess
'
' ���: LibFileName     ���ļ���
'
Public Sub LoadLibFile(ByVal LibFileName$)
    Dim FileNum&
    Dim tmpText$
    
    On Error GoTo ErrLoad:
    FileNum& = FreeFile
    
    Open LibFileName$ For Input As #FileNum
    
    ' ˳���ȡ���ļ�,���浽���� mGB2312SM$ ��
    Do While Not EOF(1)
       Line Input #FileNum, tmpText$
       mGB2312SM$ = mGB2312SM$ & tmpText$
    Loop
    Close #FileNum
    
    ' ���ؿ��ļ��ɹ�
    mLoadLibSuccess = True
    
    Exit Sub
ErrLoad:
    MsgBox "���ؿ��ļ� " & LibFileName$ & " ʧ�ܣ�", vbExclamation, "������ cHZtoSM �Ĵ���"
    mGB2312SM$ = ""
    mLoadLibSuccess = False
End Sub
'==================================================


'==================================================
' ����: HZtoSM
'
' ����: �����ַ����е�һ���ַ�����ĸ
'
' ע��: �ú����ܴ������к���,����Ҫ���ļ���֧��
'       �����������ַ������ڿ��ļ���,���������س��� ERR_RESULT$
'
' ���: Str     ���������ַ���
'
Public Function HZtoSM$(ByVal Str$)
    Dim tmpStr$, sAscii$
    Dim lAsciiU&, lAsciiL&
    Dim fPos&
    
    ' ȡ���ַ����еĵ�һ���ַ�
    tmpStr$ = Left(Str$, 1)
    
    ' ��tmpStr����Ϊ 0 ,�����޷���ֵ
    If Len(tmpStr$) <= 0 Then Exit Function
    
    ' �����ַ��� ASCII ��
    sAscii$ = Hex(Asc(tmpStr$))

    If Len(sAscii$) <> 4 Then GoTo ErrChg:
    
    ' ȡ���ַ����ֽں͵��ֽ�
    lAsciiU& = Val("&H" & Left(sAscii$, 2))
    lAsciiL& = Val("&H" & Right(sAscii$, 2))
    
    ' ��ʽ: ( ����λ - &H81 ) * ( 16 * 12 - 1 ) +
    '       ( ����λ - &H40 + 1 )
    ' ���ɼ������ĸ��Ӧ��λ��
    fPos& = (lAsciiU - &H81) * 191 + (lAsciiL& - 63)
    If fPos& < 0 Or fPos& > Len(mGB2312SM) Then GoTo ErrChg:
    
    ' �ڿ��ļ����Ҷ�Ӧ����ĸ
    HZtoSM$ = UCase(Mid(mGB2312SM, fPos&, 1))
    If (Asc(HZtoSM$) < &H41) Or (Asc(HZtoSM$) > &H90) Then GoTo ErrChg:
    
    Exit Function
ErrChg:
    ' ����ת������,���س��� ERR_RESULT
    HZtoSM$ = ERR_RESULT$
End Function
'==================================================


'==================================================
' ����: HZtoSMEx
'
' ����: �����ַ�����ÿ���ַ�����ĸ,�ɺ��� HZtoSM ��չ��
'
' ���: Str     ���������ַ���
'
Public Function HZtoSMEx$(ByVal Str$)
    Dim nPos&
    
    For nPos& = 1 To Len(Str$)
        HZtoSMEx$ = HZtoSMEx$ & HZtoSM(Mid(Str$, nPos&, 1))
    Next nPos&
End Function
'==================================================