unit main;

interface

uses
  // Delphi
  System.Classes,
  System.ImageList,
  System.SysUtils,
  // FireMonkey
  FMX.Controls,
  FMX.Controls.Presentation,
  FMX.Dialogs,
  FMX.Edit,
  FMX.EditBox,
  FMX.Forms,
  FMX.ImgList,
  FMX.ListBox,
  FMX.Menus,
  FMX.NumberBox,
  FMX.Objects,
  FMX.StdCtrls,
  FMX.Types,
  // Velthuis' BigNumbers
  Velthuis.BigIntegers,
  // web3
  web3,
  web3.eth.defi,
  web3.eth.etherscan,
  web3.eth.types,
  // Project
  apyCache;

type
  TNumberBox = class(FMX.NumberBox.TNumberBox)
  private
    FHideZero: Boolean;
    procedure SetHideZero(Value: Boolean);
  protected
    function DefinePresentationName: string; override;
  public
    property HideZero: Boolean read FHideZero write SetHideZero default False;
  end;

type
  TProvider = (Infura, Alchemy);

type
  TLendingProtocolGroup = record
    img: TGlyph;
    lbl: TLabel;
    edt: TNumberBox;
    btn: TButton;
    cbo: TComboBox;
    constructor Create(
      img: TGlyph;
      lbl: TLabel;
      edt: TNumberBox;
      btn: TButton;
      cbo: TComboBox);
    procedure Repaint;
  end;

type
  TfrmMain = class(TForm)
    edtAddress: TEdit;
    lblAddress: TLabel;
    cboCurrency: TComboBox;
    lblCompound: TLabel;
    cboChain: TComboBox;
    lblFulcrum: TLabel;
    lblAave: TLabel;
    edtCompound: TNumberBox;
    edtFulcrum: TNumberBox;
    edtAave: TNumberBox;
    btnCompound: TButton;
    btnFulcrum: TButton;
    btnAave: TButton;
    btnRefresh: TButton;
    cboCompound: TComboBox;
    cboFulcrum: TComboBox;
    cboAave: TComboBox;
    lblWallet: TLabel;
    edtWallet: TNumberBox;
    cboWallet: TComboBox;
    btnWallet: TButton;
    IL: TImageList;
    imgCompound: TGlyph;
    imgFulcrum: TGlyph;
    imgAave: TGlyph;
    MM: TMainMenu;
    mnuNetwork: TMenuItem;
    edtIdle: TNumberBox;
    btnIdle: TButton;
    cboIdle: TComboBox;
    lblIdle: TLabel;
    imgIdle: TGlyph;
    edtYearnV2: TNumberBox;
    lblYearnV2: TLabel;
    imgYearnV2: TGlyph;
    mnuPeriod: TMenuItem;
    mnuOneDay: TMenuItem;
    mnuThreeDays: TMenuItem;
    mnuOneWeek: TMenuItem;
    mnuOneMonth: TMenuItem;
    btnYearnV2: TButton;
    cboYearnV2: TComboBox;
    imgWallet: TGlyph;
    edtYearnV3: TNumberBox;
    lblYearnV3: TLabel;
    imgYearnV3: TGlyph;
    btnYearnV3: TButton;
    cboYearnV3: TComboBox;
    cboYvaultV2: TComboBox;
    btnYvaultV2: TButton;
    edtYvaultV2: TNumberBox;
    lblYvaultV2: TLabel;
    imgYvaultV2: TGlyph;
    cboOrigin: TComboBox;
    btnOrigin: TButton;
    edtOrigin: TNumberBox;
    lblOrigin: TLabel;
    imgOrigin: TGlyph;
    rctWallet: TRectangle;
    rctLendingProtocols: TRectangle;
    rctYearn: TRectangle;
    rctYieldAggregators: TRectangle;
    mnuTwoWeeks: TMenuItem;
    procedure cboChainChange(Sender: TObject);
    procedure cboCurrencyChange(Sender: TObject);
    procedure edtAddressChange(Sender: TObject);
    procedure btnCompoundClick(Sender: TObject);
    procedure btnFulcrumClick(Sender: TObject);
    procedure btnAaveClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure edtBalanceChange(Sender: TObject);
    procedure cboProtoChange(Sender: TObject);
    procedure btnWalletClick(Sender: TObject);
    procedure cboCurrencyPopup(Sender: TObject);
    procedure btnIdleClick(Sender: TObject);
    procedure mnuPeriodClick(Sender: TObject);
    procedure btnYearnV2Click(Sender: TObject);
    procedure btnYearnV3Click(Sender: TObject);
    procedure btnYvaultV2Click(Sender: TObject);
    procedure btnOriginClick(Sender: TObject);
  private
    FLockCount: Integer;
    FCurrIndex: Integer;
    FEtherscan: IEtherscan;
    procedure LockUI;
    procedure UnLockUI;
    function  Locked: Boolean;
    procedure InitUI;
    procedure UpdateUI;
    procedure HourGlass;
    function  Etherscan: IEtherscan;
    procedure UpdateSum(onExit: TProc);
    procedure UpdateAPY(onExit: TProc);
    procedure UpdateBalance(onExit: TProc);
    function  GetChain: TChain;
    function  GetClient: IWeb3; overload;
    function  GetClient(provider: TProvider): IWeb3; overload;
    function  GetEthereum: IWeb3;
    function  GetPeriod: TPeriod;
    procedure NetworkClick(Sender: TObject);
    function  GetReserve: IResult<TReserve>;
    function  GetImageIndex(aReserve: TReserve): Integer;
    function  CreateSpinner(ux: TControl): TAniIndicator;
    procedure GetAddress(callback: TProc<TAddress, IError>);
    function  IsWithdraw(const aName: string): Boolean; overload;
    function  IsWithdraw(ComboBox: TComboBox): Boolean; overload;
    function  GetAmount(box: TNumberBox; out amount: BigInteger): Boolean;
    function  GetProtoFromName(const aName: string): TLendingProtocolClass; overload;
    function  GetProtoFromName(ComboBox: TComboBox): TLendingProtocolClass; overload;
    function  GetLendingProtocolGroup(proto: TLendingProtocolClass): TLendingProtocolGroup;
    procedure Sum(client: IWeb3; owner: TAddress; reserve: TReserve; callback: TProc<TReserve, BigInteger>);
    procedure GetHighest(
      reserve : TReserve;
      period  : TPeriod;
      callback: TProc<TLendingProtocolClass, IError>);
    procedure Deposit(
      ux    : TControl;
      &to   : TLendingProtocolClass;
      amount: BigInteger); overload;
    procedure Deposit(
      client : IWeb3;
      &to    : TLendingProtocolClass;
      reserve: TReserve;
      amount : BigInteger;
      onExit : TProc); overload;
    procedure Transfer(
      ux          : TControl;
      from, &to   : TLendingProtocolClass;
      amount      : BigInteger;
      withdrawOnly: Boolean); overload;
    procedure Transfer(
      client   : IWeb3;
      from, &to: TLendingProtocolClass;
      reserve  : TReserve;
      amount   : BigInteger;
      onExit   : TProc); overload;
  public
    constructor Create(aOwner: TComponent); override;
  end;

var
  frmMain : TfrmMain;
  apyCache: array[TReserve, TPeriod] of TAPYCache;

implementation

{$R *.fmx}

uses
  // Delphi
  System.Threading,
  System.UITypes,
  // web3
  web3.error,
  web3.eth,
  web3.eth.aave.v2,
  web3.eth.alchemy,
  web3.eth.compound,
  web3.eth.fulcrum,
  web3.eth.idle.finance.v4,
  web3.eth.infura,
  web3.eth.origin.dollar,
  web3.eth.tx,
  web3.eth.yearn.finance.v2,
  web3.eth.yearn.finance.v3,
  web3.eth.yearn.vaults.v2,
  web3.utils;

{$I bankless.api.key}

const
  USD = '$USD';
  TAG_ENABLED  = 0;
  TAG_DISABLED = 1;
  TAG_CHANGED  = 2;

resourcestring
  RS_WALLET      = 'Wallet';
  RS_TRANSFER    = 'transfer';
  RS_WITHDRAW    = 'withdraw';
  RS_YOUR_WALLET = 'your wallet';
  RS_DEPOSIT_TO  = 'Deposit to';
  RS_TRANSFER_TO = 'Transfer to';
  RS_WITHDRAW_TO = 'Withdraw to';

function Rd(value: Single): Single;
begin
  Result := Round(value * 100) / 100;
end;

procedure RedOrGreen(aLabel: TLabel; highest, default: Boolean);
begin
  if default then
    { nothing }
  else
    if highest then
      aLabel.TextSettings.FontColor := TAlphaColorRec.DarkGreen
    else
      aLabel.TextSettings.FontColor := TAlphaColorRec.DarkRed;

  if default then
    aLabel.StyledSettings := aLabel.StyledSettings + [TStyledSetting.FontColor]
  else
    aLabel.StyledSettings := aLabel.StyledSettings - [TStyledSetting.FontColor];
end;

function Highest(this: Double; others: array of Double): Boolean;
begin
  for var other in others do
    if this < other then
    begin
      Result := False;
      EXIT;
    end;
  Result := True;
end;

{ TNumberBox }

function TNumberBox.DefinePresentationName: string;
begin
  if Self.HideZero and (Self.Value = 0) then
    Result := 'EditBox-' + GetPresentationSuffix
  else
    Result := inherited
end;

procedure TNumberBox.SetHideZero(Value: Boolean);
begin
  if Value <> FHideZero then
  begin
    FHideZero := Value;
    Self.ReloadPresentation;
  end;
end;

{ TLendingProtocolGroup }

constructor TLendingProtocolGroup.Create(
  img: TGlyph;
  lbl: TLabel;
  edt: TNumberBox;
  btn: TButton;
  cbo: TComboBox);
begin
  Self.img := img;
  Self.lbl := lbl;
  Self.edt := edt;
  Self.btn := btn;
  Self.cbo := cbo;
end;

procedure TLendingProtocolGroup.Repaint;
begin
  if Assigned(Self.lbl) then Self.lbl.Repaint;
  if Assigned(Self.edt) then Self.edt.Repaint;
  if Assigned(Self.btn) then Self.btn.Repaint;
  if Assigned(Self.cbo) then Self.cbo.Repaint;
end;

{ TfrmMain }

constructor TfrmMain.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  InitUI;
end;

procedure TfrmMain.edtBalanceChange(Sender: TObject);
begin
  if Locked then
    EXIT;
  if Sender is TComponent then
    TComponent(Sender).Tag := TAG_CHANGED;
end;

procedure TfrmMain.edtAddressChange(Sender: TObject);
begin
  if Locked then
    EXIT;

  Self.HourGlass;

  var bStep1: Boolean;
  var bStep2: Boolean;

  const onExit = procedure
  begin
    if bStep1 and bStep2 then
      TThread.Synchronize(nil, procedure
      begin
        Self.Cursor := crDefault;
        Self.MouseMove([], -1, -1);
      end);
  end;

  UpdateSum(procedure
  begin
    bStep1 := True;
    onExit();
  end);

  UpdateBalance(procedure
  begin
    bStep2 := True;
    onExit();
  end);
end;

procedure TfrmMain.mnuPeriodClick(Sender: TObject);
begin
  if Locked then
    EXIT;

  Self.HourGlass;

  var bStep1: Boolean;
  var bStep2: Boolean;

  const onExit = procedure
  begin
    if bStep1 and bStep2 then
      TThread.Synchronize(nil, procedure
      begin
        Self.Cursor := crDefault;
        Self.MouseMove([], -1, -1);
      end);
  end;

  UpdateAPY(procedure
  begin
    bStep1 := True;
    onExit();
  end);

  UpdateBalance(procedure
  begin
    bStep2 := True;
    onExit();
  end);
end;

procedure TfrmMain.LockUI;
begin
  Inc(FLockCount);
end;

procedure TfrmMain.UnLockUI;
begin
  if Locked then Dec(FLockCount);
end;

function TfrmMain.Locked: Boolean;
begin
  Result := FLockCount > 0;
end;

function TfrmMain.CreateSpinner(ux: TControl): TAniIndicator;
begin
  Result := TAniIndicator.Create(Self);
  Result.Parent := Self;
  Result.Width  := 30;
  Result.Height := Result.Width;
  Result.Position.X := ux.Position.X + ((ux.Width - Result.Width) / 2);
  Result.Position.Y := ux.Position.Y + ((ux.Height - Result.Height) / 2);
  Result.Enabled := True;
end;

procedure TfrmMain.btnAaveClick(Sender: TObject);
begin
  var amount: BigInteger;
  if GetAmount(edtAave, amount) then
    Transfer(btnAave, TAave, GetProtoFromName(cboAave), amount, IsWithdraw(cboAave));
end;

procedure TfrmMain.btnCompoundClick(Sender: TObject);
begin
  var amount: BigInteger;
  if GetAmount(edtCompound, amount) then
    Transfer(btnCompound, TCompound, GetProtoFromName(cboCompound), amount, IsWithdraw(cboCompound));
end;

procedure TfrmMain.btnFulcrumClick(Sender: TObject);
begin
  var amount: BigInteger;
  if GetAmount(edtFulcrum, amount) then
    Transfer(btnFulcrum, TFulcrum, GetProtoFromName(cboFulcrum), amount, IsWithdraw(cboFulcrum));
end;

procedure TfrmMain.btnIdleClick(Sender: TObject);
begin
  var amount: BigInteger;
  if GetAmount(edtIdle, amount) then
    Transfer(btnIdle, TIdle, GetProtoFromName(cboIdle), amount, IsWithdraw(cboIdle));
end;

procedure TfrmMain.btnYearnV2Click(Sender: TObject);
begin
  var amount: BigInteger;
  if GetAmount(edtYearnV2, amount) then
    Transfer(btnYearnV2, TyEarnV2, GetProtoFromName(cboYearnV2), amount, IsWithdraw(cboYearnV2));
end;

procedure TfrmMain.btnYearnV3Click(Sender: TObject);
begin
  var amount: BigInteger;
  if GetAmount(edtYearnV3, amount) then
    Transfer(btnYearnV3, TyEarnV3, GetProtoFromName(cboYearnV3), amount, IsWithdraw(cboYearnV3));
end;

procedure TfrmMain.btnYvaultV2Click(Sender: TObject);
begin
  var amount: BigInteger;
  if GetAmount(edtYvaultV2, amount) then
    Transfer(btnYvaultV2, TyVaultV2, GetProtoFromName(cboYvaultV2), amount, IsWithdraw(cboYvaultV2));
end;

procedure TfrmMain.btnOriginClick(Sender: TObject);
begin
  var amount: BigInteger;
  if GetAmount(edtOrigin, amount) then
    Transfer(btnOrigin, TOrigin, GetProtoFromName(cboOrigin), amount, IsWithdraw(cboOrigin));
end;

procedure TfrmMain.btnRefreshClick(Sender: TObject);
begin
  UpdateUI;
end;

procedure TfrmMain.btnWalletClick(Sender: TObject);
begin
  var amount: BigInteger;
  if GetAmount(edtWallet, amount) then
    Deposit(btnWallet, GetProtoFromName(cboWallet), amount);
end;

procedure TfrmMain.cboChainChange(Sender: TObject);
begin
  if Locked then
    EXIT;

  const this = GetChain;
  for var I := 0 to Pred(mnuNetwork.ItemsCount) do
  begin
    const that = web3.Chain(mnuNetwork.Items[I].Tag);
    mnuNetwork.Items[I].IsChecked := that.isOk and (that.Value^ = this);
  end;

  UpdateUI;
end;

procedure TfrmMain.cboProtoChange(Sender: TObject);

  function getButton(Sender: TObject): TButton;
  begin
    if Sender = cboCompound then
      Result := btnCompound
    else if Sender = cboFulcrum then
      Result := btnFulcrum
    else if Sender = cboAave then
      Result := btnAave
    else if Sender = cboIdle then
      Result := btnIdle
    else if Sender = cboYearnV2 then
      Result := btnYearnV2
    else if Sender = cboYearnV3 then
      Result := btnYearnV3
    else if Sender = cboYvaultV2 then
      Result := btnYvaultV2
    else if Sender = cboOrigin then
      Result := btnOrigin
    else
      Result := nil;
  end;

begin
  const button = getButton(Sender);
  if not Assigned(button) then
    EXIT;
  if not(Sender is TComboBox) then
    EXIT;
  const comboBox = TComboBox(Sender);
  const idx = ComboBox.ItemIndex;
  if idx = -1 then
    EXIT;
  if SameText(ComboBox.Items[idx], RS_WALLET) then
    button.Text := RS_WITHDRAW_TO
  else
    button.Text := RS_TRANSFER_TO;
end;

procedure TfrmMain.cboCurrencyChange(Sender: TObject);
begin
  if Locked then
    EXIT;

  with cboCurrency do
    if (ItemIndex > -1) and (ItemIndex < Items.Count) then
      if Integer(Items.Objects[ItemIndex]) < 0 then
      begin
        LockUI;
        try
          ItemIndex := FCurrIndex;
        finally
          UnLockUI;
        end;
        EXIT;
      end;

  UpdateUI;
end;

procedure TfrmMain.cboCurrencyPopup(Sender: TObject);
begin
  FCurrIndex := cboCurrency.ItemIndex;
end;

function TfrmMain.GetChain: TChain;
begin
  const I = cboChain.ItemIndex;
  if (I > -1) and (I < cboChain.Count) then
  begin
    const chain = web3.Chain(UInt32(cboChain.Items.Objects[I]));
    if chain.isOk then
    begin
      Result := chain.Value^;
      EXIT;
    end;
  end;
  Result := web3.Ethereum;
end;

function TfrmMain.GetClient: IWeb3;
begin
  Result := GetClient(Infura);
end;

function TfrmMain.GetClient(provider: TProvider): IWeb3;
begin
  const chain = Self.GetChain;
  if provider = Infura then
    Result := TWeb3.Create(chain.SetRPC(HTTPS, web3.eth.infura.endpoint(chain, INFURA_PROJECT_ID).Value))
  else
    Result := TWeb3.Create(chain.SetRPC(HTTPS, web3.eth.alchemy.endpoint(chain, ALCHEMY_PROJECT_ID, core).Value));
end;

function TfrmMain.GetEthereum: IWeb3;
begin
  Result := TWeb3.Create(Ethereum.SetRPC(HTTPS, web3.eth.infura.endpoint(Ethereum, INFURA_PROJECT_ID).Value));
end;

function TfrmMain.GetPeriod: TPeriod;
begin
  Result := oneMonth;
  if mnuOneDay.IsChecked then
    Result := oneDay
  else if mnuThreeDays.IsChecked then
    Result := threeDays
  else if mnuOneWeek.IsChecked then
    Result := oneWeek
  else if mnuTwoWeeks.IsChecked then
    Result := twoWeeks;
end;

function TfrmMain.GetReserve: IResult<TReserve>;
begin
  with cboCurrency do
    if (ItemIndex > -1) and (ItemIndex < Items.Count) then
    begin
      const I = Integer(Items.Objects[ItemIndex]);
      if I >= 0 then
      begin
        Result := TResult<TReserve>.Ok(TReserve(I));
        EXIT;
      end;
    end;
  Result := TResult<TReserve>.Err(DAI, 'Unknown reserve');
end;

function TfrmMain.GetImageIndex(aReserve: TReserve): Integer;
begin
  for Result := 0 to Pred(IL.Source.Count) do
    if SameText(IL.Source.Items[Result].Name, aReserve.Symbol) then
      EXIT;
  Result := -1;
end;

procedure TfrmMain.GetAddress(callback: TProc<TAddress, IError>);
begin
  if edtAddress.Text.Length = 0 then
    callback(EMPTY_ADDRESS, nil)
  else
    TAddress.Create(GetEthereum, edtAddress.Text, callback);
end;

function TfrmMain.GetAmount(box: TNumberBox; out amount: BigInteger): Boolean;
begin
  Result := True;
  amount := BigInteger.Zero;
  if Assigned(box) and (box.Tag = TAG_CHANGED) then
  begin
    const R = GetReserve;
    if R.isOk then
    begin
      amount := R.Value.Scale(box.Value);
      Result := amount > 0;
      if not Result then
        web3.error.show('Nothing to do. Please enter a positive amount.');
    end;
  end;
end;

function TfrmMain.IsWithdraw(const aName: string): Boolean;
begin
  Result := SameText(aName, RS_WALLET);
end;

function TfrmMain.IsWithdraw(ComboBox: TComboBox): Boolean;
begin
  Result := False;
  if Assigned(ComboBox) then
  begin
    const I = ComboBox.ItemIndex;
    if (I > -1) and (I < ComboBox.Items.Count) then
      Result := IsWithdraw(ComboBox.Items[I]);
  end;
end;

function TfrmMain.GetProtoFromName(const aName: string): TLendingProtocolClass;
begin
  if SameText(aName, TCompound.Name) then
    Result := TCompound
  else if SameText(aName, TFulcrum.Name) then
    Result := TFulcrum
  else if SameText(aName, TAave.Name) then
    Result := TAave
  else if SameText(aName, TIdle.Name) then
    Result := TIdle
  else if SameText(aName, TyEarnV2.Name) then
    Result := TyEarnV2
  else if SameText(aName, TyEarnV3.Name) then
    Result := TyEarnV3
  else if SameText(aName, TyVaultV2.Name) then
    Result := TyVaultV2
  else if SameText(aName, TOrigin.Name) then
    Result := TOrigin
  else
    Result := nil; // highest (or withdraw)
end;

function TfrmMain.GetProtoFromName(ComboBox: TComboBox): TLendingProtocolClass;
begin
  Result := nil;
  if Assigned(ComboBox) then
  begin
    const I = ComboBox.ItemIndex;
    if (I > -1) and (I < ComboBox.Items.Count) then
      Result := GetProtoFromName(ComboBox.Items[I]);
  end;
end;

procedure TfrmMain.NetworkClick(Sender: TObject);
begin
  if not(Sender is TMenuItem) then
    EXIT;
  TMenuItem(Sender).IsChecked := True;
  const C = web3.Chain(TMenuItem(Sender).Tag);
  if C.isOk then
    cboChain.ItemIndex := cboChain.Items.IndexOfObject(TObject(C.Value^.Id));
end;

procedure TfrmMain.InitUI;
begin
  try
    LockUI;
    try
      ClientHeight := Round(btnRefresh.BoundsRect.Bottom) + 12;

      (procedure(chains: array of TChain)

        function NewMenuItem(const aCaption: string; aChainId: UInt32): TMenuItem;
        begin
          Result := TMenuItem.Create(Self);
          Result.Text       := aCaption;
          Result.Tag        := aChainId;
          Result.GroupIndex := 1;
          Result.RadioItem  := True;
          Result.IsChecked  := aChainId = Ethereum.Id;
          Result.OnClick    := NetworkClick;
        end;

      begin
        for var C in chains do
        begin
          cboChain.Items.AddObject(C.Name, TObject(C.Id));
          mnuNetwork.AddObject(NewMenuItem(C.Name, C.Id));
        end;
      end)([Ethereum]);

      cboChain.ItemIndex := 0;
      cboChain.Enabled := cboChain.Items.Count > 1;

      for var R := System.Low(TReserve) to High(TReserve) do
        cboCurrency.Items.AddObject('$' + R.Symbol, TObject(R));

      cboCurrency.Items.AddObject('――――――――― +', TObject(-1));
      cboCurrency.ListItems[Pred(cboCurrency.Items.Count)].Selectable := False;

      cboCurrency.Items.AddObject(USD, TObject(-1));
      cboCurrency.ListItems[Pred(cboCurrency.Items.Count)].Selectable := False;

      cboCurrency.ItemIndex := 0;
    finally
      UnLockUI;
    end;
  finally
    UpdateUI;
  end;
end;

procedure TfrmMain.HourGlass;
begin
  Self.Cursor := crHourGlass;
  Self.MouseMove([], -1, -1);
end;

function TfrmMain.Etherscan: IEtherscan;
begin
  if not Assigned(FEtherscan) then
    FEtherscan := web3.eth.etherscan.create(Self.GetChain, ETHERSCAN_API_KEY);
  Result := FEtherscan;
end;

procedure TfrmMain.UpdateUI;
begin
  Self.HourGlass;

  var bStep1 : Boolean;
  var bStep2 : Boolean;
  var bStep3 : Boolean;

  const onExit = procedure
  begin
    if bStep1 and bStep2 and bStep3 then
      TThread.Synchronize(nil, procedure
      begin
        Self.Cursor := crDefault;
        Self.MouseMove([], -1, -1);
      end);
  end;

  GetReserve
    .ifOk(procedure(reserve: TReserve)
    begin
      imgWallet.ImageIndex := GetImageIndex(reserve)
    end)
    .&else(procedure(_: IError)
    begin
      imgWallet.ImageIndex := -1
    end);

  UpdateSum(procedure
  begin
    bStep1 := True;
    onExit();
  end);

  UpdateAPY(procedure
  begin
    bStep2 := True;
    onExit();
  end);

  UpdateBalance(procedure
  begin
    bStep3 := True;
    onExit();
  end);
end;

procedure TfrmMain.UpdateSum(onExit: TProc);
type
  TSummary = array[TReserve] of Double;
begin
  const client: IWeb3 = GetClient;

  GetAddress(procedure(owner: TAddress; err: IError)

    function Init: TSummary;
    begin
      for var R := System.Low(TSummary) to High(TSummary) do
        Result[R] := -1;
    end;

  begin
    var S: TSummary := Init;

    for var I := 0 to Pred(cboCurrency.Items.Count) do
    begin
      const O = cboCurrency.Items.Objects[I];
      if Integer(O) >= 0 then
      begin
        const R = TReserve(O);
        Sum(client, owner, R, procedure(reserve: TReserve; sum: BigInteger)

          function Done(sum: TSummary): Boolean;
          begin
            Result := True;
            for var R := System.Low(sum) to High(sum) do
              if sum[R] = -1 then
                EXIT(False);
          end;

        begin
          S[reserve] := reserve.Unscale(sum);

          TThread.Synchronize(nil, procedure
          begin
            LockUI;
            try
              cboCurrency.Items.BeginUpdate;
              try
                const I = cboCurrency.Items.IndexOfObject(TObject(reserve));
                if I > -1 then
                  cboCurrency.Items[I] := '$' + reserve.Symbol + #9 + Format('%.2f', [reserve.Unscale(sum)]);
              finally
                cboCurrency.Items.EndUpdate;
              end;
            finally
              UnLockUI;
            end;
          end);

          if Done(S) then
            TThread.Synchronize(nil, procedure

              function Summary(sum: TSummary): Double;
              begin
                Result := 0;
                for var R := System.Low(sum) to High(sum) do
                  if sum[R] > -1 then
                    Result := Result + sum[R];
              end;

            begin
              LockUI;
              try
                cboCurrency.Items.BeginUpdate;
                try
                  cboCurrency.Items[Pred(cboCurrency.Items.Count)] := USD + #9 + Format('%.2f', [Summary(S)]);
                finally
                  cboCurrency.Items.EndUpdate;
                end;
                cboCurrency.Repaint;
              finally
                UnLockUI;
                if Assigned(onExit) then onExit;
              end;
            end);
        end);
      end;
    end;
  end);
end;

procedure TfrmMain.UpdateAPY(onExit: TProc);
begin
  const aClient = GetClient(Alchemy);
  const aPeriod = GetPeriod;

  const aReserve = GetReserve;
  if aReserve.isErr then
  begin
    if Assigned(onExit) then onExit;
    EXIT;
  end;

  lblWallet.Text := Format('%s in my wallet', [aReserve.Value.Symbol]);

  const disable = procedure(proto: TLendingProtocolClass)
  begin
    var group := GetLendingProtocolGroup(proto);
    group.img.Opacity := 0.5;
    group.lbl.Text    := proto.Name;
    group.lbl.Enabled := False;
  end;

  const enable = procedure(proto: TLendingProtocolClass; sep: string; APY: Double)
  begin
    var group := GetLendingProtocolGroup(proto);
    group.img.Opacity := 1;
    group.lbl.Text    := proto.Name + sep + Format('%.2f%%', [APY]);
    group.lbl.Enabled := True;
  end;

  apyCache[aReserve.Value, aPeriod].Get(aClient, Etherscan, aReserve.Value, aPeriod,
    procedure(C, F, A, I, Y2, Y3, V2, O: Double; err: IError)
    begin
      if Assigned(err) then
      begin
        web3.error.show(aClient.Chain, err);
        onExit;
        EXIT;
      end;

      TThread.Synchronize(nil, procedure
      begin
        if C = -1 then
          disable(TCompound)
        else
          enable(TCompound, #9, C);
        if F = -1 then
          disable(TFulcrum)
        else
          enable(TFulcrum, #32 + #9#9, F);
        if A = -1 then
          disable(TAave)
        else
          enable(TAave, #9#9, A);
        if I = -1 then
          disable(TIdle)
        else
          enable(TIdle, #32#32#32 + #9#9, I);
        if Y2 = -1 then
          disable(TyEarnV2)
        else
          enable(TyEarnV2, #9#9, Y2);
        if Y3 = -1 then
          disable(TyEarnV3)
        else
          enable(TyEarnV3, #9#9, Y3);
        if V2 = -1 then
          disable(TyVaultV2)
        else
          enable(TyVaultV2, #9#9, V2);
        if O = -1 then
          disable(TOrigin)
        else
          enable(TOrigin, #32#32 + #9#9, O);
      end);

      if Assigned(onExit) then onExit;
    end);
end;

function TfrmMain.GetLendingProtocolGroup(proto: TLendingProtocolClass): TLendingProtocolGroup;
begin
  if proto = TCompound then
    Result := TLendingProtocolGroup.Create(imgCompound, lblCompound, edtCompound, btnCompound, cboCompound)
  else if proto = TFulcrum then
    Result := TLendingProtocolGroup.Create(imgFulcrum, lblFulcrum, edtFulcrum, btnFulcrum, cboFulcrum)
  else if proto = TAave then
    Result := TLendingProtocolGroup.Create(imgAave, lblAave, edtAave, btnAave, cboAave)
  else if proto = TIdle then
    Result := TLendingProtocolGroup.Create(imgIdle, lblIdle, edtIdle, btnIdle, cboIdle)
  else if proto = TyEarnV2 then
    Result := TLendingProtocolGroup.Create(imgYearnV2, lblYearnV2, edtYearnV2, btnYearnV2, cboYearnV2)
  else if proto = TyEarnV3 then
    Result := TLendingProtocolGroup.Create(imgYearnV3, lblYearnV3, edtYearnV3, btnYearnV3, cboYearnV3)
  else if proto = TyVaultV2 then
    Result := TLendingProtocolGroup.Create(imgYvaultV2, lblYvaultV2, edtYvaultV2, btnYvaultV2, cboYvaultV2)
  else if proto = TOrigin then
    Result := TLendingProtocolGroup.Create(imgOrigin, lblOrigin, edtOrigin, btnOrigin, cboOrigin);
end;

procedure TfrmMain.UpdateBalance(onExit: TProc);
begin
  var aHighest: TLendingProtocolClass := nil;

  const aClient = GetClient;
  const aPeriod = GetPeriod;

  const aReserve = GetReserve;
  if aReserve.isErr then
  begin
    if Assigned(onExit) then onExit;
    EXIT;
  end;

  const disable = procedure(proto: TLendingProtocolClass; highest: Boolean)
  begin
    const group = GetLendingProtocolGroup(proto);
    RedOrGreen(group.lbl, highest, True);
    LockUI;
    try
      group.edt.Value    := 0;
      group.edt.HideZero := True;
      group.edt.Enabled  := False;
    finally
      UnLockUI;
    end;
    if Assigned(group.cbo) then
    begin
      group.cbo.ItemIndex := -1;
      group.cbo.Enabled   := False;
    end;
    if Assigned(group.btn) then
    begin
      group.btn.Text    := '';
      group.btn.Enabled := False;
    end;
    group.lbl.Repaint;
  end;

  const enable = procedure(proto: TLendingProtocolClass; balance: BigInteger; highest: Boolean)
  begin
    const group = GetLendingProtocolGroup(proto);
    RedOrGreen(group.lbl, highest, (Rd(aReserve.Value.Unscale(balance)) = 0) and not highest);
    try
      LockUI;
      try
        group.edt.Value    := aReserve.Value.Unscale(balance);
        group.edt.HideZero := False;
        group.edt.Tag      := TAG_ENABLED;
      finally
        UnLockUI;
      end;
      if Assigned(group.cbo) then
      try
        if highest then
          group.cbo.ItemIndex := group.cbo.Items.IndexOf(RS_WALLET)
        else
          group.cbo.ItemIndex := 0;
      finally
        group.cbo.Enabled := (Rd(group.edt.Value) > 0) and not highest;
      end;
      if Assigned(group.edt) then
        group.edt.Enabled := (Rd(group.edt.Value) > 0);
      if Assigned(group.btn) then
        group.btn.Enabled := (group.btn.Tag = TAG_ENABLED) and (Rd(group.edt.Value) > 0);
    finally
      group.Repaint;
    end;
  end;

  GetHighest(aReserve.Value, aPeriod, procedure(highest: TLendingProtocolClass; err: IError)
  begin
    aHighest := highest;

    var W, C, F, A, I, Y2, Y3, V2, O: Boolean;

    GetAddress(procedure(aAddress: TAddress; err: IError)
    begin
      aReserve.Value.BalanceOf(aClient, aAddress, procedure(value: BigInteger; err: IError)
      begin
        W := True;
        TThread.Synchronize(nil, procedure
        begin
          LockUI;
          try
            edtWallet.Value    := aReserve.Value.Unscale(value);
            edtWallet.HideZero := False;
            edtWallet.Tag      := TAG_ENABLED;
            edtWallet.Enabled  := Rd(edtWallet.Value) > 0;
          finally
            UnLockUI;
          end;
          try
            cboWallet.ItemIndex := 0;
            cboWallet.Enabled   := Rd(edtWallet.Value) > 0;
            btnWallet.Text      := RS_DEPOSIT_TO;
            btnWallet.Enabled   := (btnWallet.Tag = TAG_ENABLED) and (Rd(edtWallet.Value) > 0);
          finally
            edtWallet.Repaint;
            cboWallet.Repaint;
            btnWallet.Repaint;
          end;
        end);
      end);

      if not TCompound.Supports(aClient.Chain, aReserve.Value) then
      begin
        C := True;
        TThread.Synchronize(nil, procedure
        begin
          disable(TCompound, aHighest = TCompound);
        end);
      end
      else
        TCompound.Balance(aClient, aAddress, aReserve.Value, procedure(value: BigInteger; err: IError)
        begin
          C := True;
          TThread.Synchronize(nil, procedure
          begin
            enable(TCompound, value, aHighest = TCompound);
          end);
        end);

      if not TFulcrum.Supports(aClient.Chain, aReserve.Value) then
      begin
        F := True;
        TThread.Synchronize(nil, procedure
        begin
          disable(TFulcrum, aHighest = TFulcrum);
        end);
      end
      else
        TFulcrum.Balance(aClient, aAddress, aReserve.Value, procedure(value: BigInteger; err: IError)
        begin
          F := True;
          TThread.Synchronize(nil, procedure
          begin
            enable(TFulcrum, value, aHighest = TFulcrum);
          end);
        end);

      if not TAave.Supports(aClient.Chain, aReserve.Value) then
      begin
        A := True;
        TThread.Synchronize(nil, procedure
        begin
          disable(TAave, aHighest = TAave);
        end);
      end
      else
        TAave.Balance(aClient, aAddress, aReserve.Value, procedure(value: BigInteger; err: IError)
        begin
          A := True;
          TThread.Synchronize(nil, procedure
          begin
            enable(TAave, value, aHighest = TAave);
          end);
        end);

      if not TIdle.Supports(aClient.Chain, aReserve.Value) then
      begin
        I := True;
        TThread.Synchronize(nil, procedure
        begin
          disable(TIdle, aHighest = TIdle);
        end);
      end
      else
        TIdle.Balance(aClient, aAddress, aReserve.Value, procedure(value: BigInteger; err: IError)
        begin
          I := True;
          TThread.Synchronize(nil, procedure
          begin
            enable(TIdle, value, aHighest = TIdle);
          end);
        end);

      if not TyEarnV2.Supports(aClient.Chain, aReserve.Value) then
      begin
        Y2 := True;
        TThread.Synchronize(nil, procedure
        begin
          disable(TyEarnV2, aHighest = TyEarnV2);
        end);
      end
      else
        TyEarnV2.Balance(aClient, aAddress, aReserve.Value, procedure(value: BigInteger; err: IError)
        begin
          Y2 := True;
          TThread.Synchronize(nil, procedure
          begin
            enable(TyEarnV2, value, aHighest = TyEarnV2);
          end);
        end);

      if not TyEarnV3.Supports(aClient.Chain, aReserve.Value) then
      begin
        Y3 := True;
        TThread.Synchronize(nil, procedure
        begin
          disable(TyEarnV3, aHighest = TyEarnV3);
        end);
      end
      else
        TyEarnV3.Balance(aClient, aAddress, aReserve.Value, procedure(value: BigInteger; err: IError)
        begin
          Y3 := True;
          TThread.Synchronize(nil, procedure
          begin
            enable(TyEarnV3, value, aHighest = TyEarnV3);
          end);
        end);

      if not TyVaultV2.Supports(aClient.Chain, aReserve.Value) then
      begin
        V2 := True;
        TThread.Synchronize(nil, procedure
        begin
          disable(TyVaultV2, aHighest = TyVaultV2);
        end);
      end
      else
        TyVaultV2.Balance(aClient, aAddress, aReserve.Value, procedure(value: BigInteger; err: IError)
        begin
          V2 := True;
          TThread.Synchronize(nil, procedure
          begin
            enable(TyVaultV2, value, aHighest = TyVaultV2);
          end);
        end);

      if not TOrigin.Supports(aClient.Chain, aReserve.Value) then
      begin
        O := True;
        TThread.Synchronize(nil, procedure
        begin
          disable(TOrigin, aHighest = TOrigin);
        end);
      end
      else
        TOrigin.Balance(aClient, aAddress, aReserve.Value, procedure(value: BigInteger; err: IError)
        begin
          O := True;
          TThread.Synchronize(nil, procedure
          begin
            enable(TOrigin, value, aHighest = TOrigin);
          end);
        end);
    end);

    if Assigned(onExit) then
      TTask.Create(procedure
      begin
        while TTask.CurrentTask.Status <> TTaskStatus.Canceled do
        begin
          try
            TTask.CurrentTask.Wait(250);
          except end;
          if W and C and F and A and I and Y2 and Y3 and V2 and O then
          begin
            onExit;
            EXIT;
          end;
        end;
      end).Start;
  end);
end;

procedure TfrmMain.GetHighest(
  reserve : TReserve;
  period  : TPeriod;
  callback: TProc<TLendingProtocolClass, IError>);
begin
  apyCache[reserve, period].Get(GetClient(Alchemy), Etherscan, reserve, period,
    procedure(C, F, A, I, Y2, Y3, V2, O: Double; err: IError)
    begin
      if Assigned(err) then
        callback(nil, err)
      else if Highest(C, [F, A, I, Y2, Y3, V2, O]) then
        callback(TCompound, nil)
      else if Highest(F, [C, A, I, Y2, Y3, V2, O]) then
        callback(TFulcrum, nil)
      else if Highest(A, [C, F, I, Y2, Y3, V2, O]) then
        callback(TAave, nil)
      else if Highest(I, [C, F, A, Y2, Y3, V2, O]) then
        callback(TIdle, nil)
      else if Highest(Y2, [C, F, A, I, Y3, V2, O]) then
        callback(TyEarnV2, nil)
      else if Highest(Y3, [C, F, A, I, Y2, V2, O]) then
        callback(TyEarnV3, nil)
      else if Highest(V2, [C, F, A, I, Y2, Y3, O]) then
        callback(TyVaultV2, nil)
      else if Highest(O, [C, F, A, I, Y2, Y3, V2]) then
        callback(TOrigin, nil);
    end);
end;

procedure TfrmMain.Sum(client: IWeb3; owner: TAddress; reserve: TReserve; callback: TProc<TReserve, BigInteger>);
begin
  var W, C, F, A, I, Y2, Y3, V2, O: BigInteger;

  reserve.BalanceOf(client, owner, procedure(value: BigInteger; err: IError)
  begin
    if value > 0 then
      W := value
    else
      W := -1;
  end);

  if not TCompound.Supports(client.Chain, reserve) then
    C := -1
  else
    TCompound.Balance(client, owner, reserve, procedure(value: BigInteger; err: IError)
    begin
      if value > 0 then
        C := value
      else
        C := -1;
    end);

  if not TFulcrum.Supports(client.Chain, reserve) then
    F := -1
  else
    TFulcrum.Balance(client, owner, reserve, procedure(value: BigInteger; err: IError)
    begin
      if value > 0 then
        F := value
      else
        F := -1;
    end);

  if not TAave.Supports(client.Chain, reserve) then
    A := -1
  else
    TAave.Balance(client, owner, reserve, procedure(value: BigInteger; err: IError)
    begin
      if value > 0 then
        A := value
      else
        A := -1;
    end);

  if not TIdle.Supports(client.Chain, reserve) then
    I := -1
  else
    TIdle.Balance(client, owner, reserve, procedure(value: BigInteger; err: IError)
    begin
      if value > 0 then
        I := value
      else
        I := -1;
    end);

  if not TyEarnV2.Supports(client.Chain, reserve) then
    Y2 := -1
  else
    TyEarnV2.Balance(client, owner, reserve, procedure(value: BigInteger; err: IError)
    begin
      if value > 0 then
        Y2 := value
      else
        Y2 := -1;
    end);

  if not TyEarnV3.Supports(client.Chain, reserve) then
    Y3 := -1
  else
    TyEarnV3.Balance(client, owner, reserve, procedure(value: BigInteger; err: IError)
    begin
      if value > 0 then
        Y3 := value
      else
        Y3 := -1;
    end);

  if not TyVaultV2.Supports(client.Chain, reserve) then
    V2 := -1
  else
    TyVaultV2.Balance(client, owner, reserve, procedure(value: BigInteger; err: IError)
    begin
      if value > 0 then
        V2 := value
      else
        V2 := -1;
    end);

  if not TOrigin.Supports(client.Chain, reserve) then
    O := -1
  else
    TOrigin.Balance(client, owner, reserve, procedure(value: BigInteger; err: IError)
    begin
      if value > 0 then
        O := value
      else
        O := -1;
    end);

  TTask.Create(procedure
  begin
    var output: BigInteger;
    while TTask.CurrentTask.Status <> TTaskStatus.Canceled do
    begin
      try
        TTask.CurrentTask.Wait(250);
      except end;
      if  ((W = -1)  or (W > 0))
      and ((C = -1)  or (C > 0))
      and ((F = -1)  or (F > 0))
      and ((A = -1)  or (A > 0))
      and ((I = -1)  or (I > 0))
      and ((Y2 = -1) or (Y2 > 0))
      and ((Y3 = -1) or (Y3 > 0))
      and ((V2 = -1) or (V2 > 0))
      and ((O = -1)  or (O > 0)) then
      begin
        output := 0;
        if W > 0 then
          output := output + W;
        if C > 0 then
          output := output + C;
        if F > 0 then
          output := output + F;
        if A > 0 then
          output := output + A;
        if I > 0 then
          output := output + I;
        if Y2 > 0 then
          output := output + Y2;
        if Y3 > 0 then
          output := output + Y3;
        if V2 > 0 then
          output := output + V2;
        if O > 0 then
          output := output + O;
        callback(reserve, output);
        EXIT;
      end;
    end;
  end).Start;
end;

procedure TfrmMain.Deposit(
  ux    : TControl;
  &to   : TLendingProtocolClass;
  amount: BigInteger);
begin
  const aClient = GetClient;
  const aPeriod = GetPeriod;

  const aReserve = GetReserve;
  if aReserve.isErr then
    EXIT;

  ux.Enabled := False;
  ux.Tag := TAG_DISABLED;
  var aSpinner := CreateSpinner(ux);

  const onExit: TProc = procedure
  begin
    TThread.Synchronize(nil, procedure
    begin
      if Assigned(aSpinner) then
      begin
        aSpinner.Free;
        aSpinner := nil;
      end;
      ux.Enabled := True;
      ux.Tag := TAG_ENABLED;
    end);
  end;

  if Assigned(&to) then
  begin
    Deposit(aClient, &to, aReserve.Value, amount, onExit);
    EXIT;
  end;

  GetHighest(aReserve.Value, aPeriod, procedure(highest: TLendingProtocolClass; err: IError)
  begin
    if Assigned(err) then
    begin
      web3.error.show(aClient.Chain, err);
      onExit();
      EXIT;
    end;

    Deposit(aClient, highest, aReserve.Value, amount, onExit);
  end);
end;

procedure TfrmMain.Deposit(
  client : IWeb3;
  &to    : TLendingProtocolClass;
  reserve: TReserve;
  amount : BigInteger;
  onExit : TProc);
begin
  if Assigned(&to) and not &to.Supports(client.Chain, reserve) then
  begin
    web3.error.show(Format('Cannot deposit. %s is not deployed on %s.', [&to.Name, client.Chain.Name]));
    onExit;
    EXIT;
  end;

  GetAddress(procedure(&public: TAddress; err: IError)
  begin
    if Assigned(err) then
    begin
      web3.error.show(client.Chain, err);
      onExit;
      EXIT;
    end;

    reserve.BalanceOf(client, &public, procedure(value: BigInteger; err: IError)
    begin
      if Assigned(err) then
      begin
        web3.error.show(client.Chain, err);
        onExit;
        EXIT;
      end;

      const balance = value;

      if balance = 0 then
      begin
        web3.error.show('Nothing to do. Your wallet balance is zero.');
        onExit;
        EXIT;
      end;

      if not amount.IsZero then
        if amount > balance then
        begin
          web3.error.show(Format('Cannot deposit. %s %f is more than your current balance.', [reserve.Symbol, reserve.Unscale(amount)]));
          onExit;
          EXIT;
        end;

      const qty = (function: BigInteger
      begin
        if amount.IsZero then
          Result := balance
        else
          Result := amount;
      end)();

      var MR: Integer;
      TThread.Synchronize(nil, procedure
      begin
{$WARN SYMBOL_DEPRECATED OFF}
        MR := MessageDlg(Format(
          'Are you sure you want to deposit %s %f from your wallet to %s?', [
            reserve.Symbol,
            reserve.Unscale(qty),
            &to.Name
          ]), TMsgDlgType.mtConfirmation, mbYesNo, 0);
{$WARN SYMBOL_DEPRECATED DEFAULT}
      end);
      if MR <> mrYes then
      begin
        onExit;
        EXIT;
      end;

      const &private = TPrivateKey.Prompt(&public);
      if &private.isErr then
      begin
        if Supports(&private.Error, ICancelled) then
          { nothing }
        else
          web3.error.show(client.Chain, &private.Error);
        onExit;
        EXIT;
      end;

      &to.Deposit(client, &private.Value, reserve, qty, procedure(rcpt: ITxReceipt; err: IError)
      begin
        try
          if Assigned(err) then
            web3.error.show(client.Chain, err)
          else
            openTransaction(client.Chain, rcpt.txHash);
        finally
          UpdateBalance(onExit);
        end;
      end);
    end);
  end);
end;

procedure TfrmMain.Transfer(
  ux          : TControl;
  from, &to   : TLendingProtocolClass;
  amount      : BigInteger;
  withdrawOnly: Boolean);
begin
  const aClient = GetClient;
  const aPeriod = GetPeriod;

  const aReserve = GetReserve;
  if aReserve.isErr then
    EXIT;

  ux.Enabled := False;
  ux.Tag := TAG_DISABLED;
  var aSpinner := CreateSpinner(ux);

  const onExit: TProc = procedure
  begin
    TThread.Synchronize(nil, procedure
    begin
      if Assigned(aSpinner) then
      begin
        aSpinner.Free;
        aSpinner := nil;
      end;
      ux.Enabled := True;
      ux.Tag := TAG_ENABLED;
    end);
  end;

  if Assigned(&to) or withdrawOnly then
  begin
    Transfer(aClient, from, &to, aReserve.Value, amount, onExit);
    EXIT;
  end;

  GetHighest(aReserve.Value, aPeriod, procedure(highest: TLendingProtocolClass; err: IError)
  begin
    if Assigned(err) then
    begin
      web3.error.show(aClient.Chain, err);
      onExit();
      EXIT;
    end;

    if highest = from then
    begin
      web3.error.show(Format('Nothing to do. %s provides the highest yield.', [from.Name]));
      onExit();
      EXIT;
    end;

    Transfer(aClient, from, highest, aReserve.Value, amount, onExit);
  end);
end;

procedure TfrmMain.Transfer(
  client   : IWeb3;
  from, &to: TLendingProtocolClass;
  reserve  : TReserve;
  amount   : BigInteger;
  onExit   : TProc);
begin
  if Assigned(&to) and not &to.Supports(client.Chain, reserve) then
  begin
    web3.error.show(Format('Cannot transfer. %s is not deployed on %s.', [&to.Name, client.Chain.Name]));
    onExit;
    EXIT;
  end;

  GetAddress(procedure(&public: TAddress; err: IError)
  begin
    if Assigned(err) then
    begin
      web3.error.show(client.Chain, err);
      onExit;
      EXIT;
    end;

    from.Balance(client, &public, reserve, procedure(value: BigInteger; err: IError)
    begin
      if Assigned(err) then
      begin
        web3.error.show(client.Chain, err);
        onExit;
        EXIT;
      end;

      const balance = value;

      if balance = 0 then
      begin
        web3.error.show(Format('Nothing to do. Your %s balance is zero.', [from.Name]));
        onExit;
        EXIT;
      end;

      if not amount.IsZero then
        if amount > balance then
        begin
          web3.error.show(Format('Cannot transfer. %s %f is more than your current balance.', [reserve.Symbol, reserve.Unscale(amount)]));
          onExit;
          EXIT;
        end;

      var MR: Integer;
      TThread.Synchronize(nil, procedure
      begin
        const qty = (function: BigInteger
        begin
          if amount.IsZero then
            Result := balance
          else
            Result := amount;
        end)();

        var action, dest: string;
        if Assigned(&to) then
        begin
          action := RS_TRANSFER.ToLower;
          dest   := &to.Name;
        end
        else
        begin
          action := RS_WITHDRAW.ToLower;
          dest   := RS_YOUR_WALLET;
        end;

{$WARN SYMBOL_DEPRECATED OFF}
        MR := MessageDlg(Format(
          'Are you sure you want to %s %s %f from %s to %s?', [
            action,
            reserve.Symbol,
            reserve.Unscale(qty),
            from.Name,
            dest
          ]), TMsgDlgType.mtConfirmation, mbYesNo, 0);
{$WARN SYMBOL_DEPRECATED DEFAULT}
      end);

      if MR <> mrYes then
      begin
        onExit;
        EXIT;
      end;

      const &private = TPrivateKey.Prompt(&public);
      if &private.isErr then
      begin
        if Supports(&private.Error, ICancelled) then
          { nothing }
        else
          web3.error.show(client.Chain, &private.Error);
        onExit;
        EXIT;
      end;

      const afterWithdraw: TProc<ITxReceipt, BigInteger, IError> = procedure(rcpt: ITxReceipt; withdrawn: BigInteger; err: IError)
      begin
        if Assigned(err) then
        begin
          web3.error.show(client.Chain, err);
          onExit;
          EXIT;
        end;

        if not Assigned(&to) then
        begin
          UpdateBalance(onExit);
          EXIT;
        end;

        &to.Deposit(client, &private.Value, reserve, withdrawn, procedure(rcpt: ITxReceipt; err: IError)
        begin
          try
            if Assigned(err) then
              web3.error.show(client.Chain, err)
            else
              openTransaction(client.Chain, rcpt.txHash);
          finally
            UpdateBalance(onExit);
          end;
        end);
      end;

      if amount.IsZero then
        from.Withdraw(client, &private.Value, reserve, afterWithdraw)
      else
        from.WithdrawEx(client, &private.Value, reserve, amount, afterWithdraw);
    end);
  end);
end;

end.
