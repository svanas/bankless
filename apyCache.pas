unit apyCache;

interface

uses
  // web3
  web3,
  web3.eth.defi;

// C  == Compound
// F  == Fulcrum
// A  == Aave
// D  == dYdX
// I  == Idle
// Y2 == Yearn earn v2
// Y3 == Yearn earn v3
// V1 == Yearn vault v1
// V2 == Yearn vault v2
// R  == Rari Capital
// O  == Origin Dollar
// M  == mStable

type
  TAsyncAPYs = reference to procedure(C, F, A, D, I, Y2, Y3, V1, V2, R, O, M: Double; err: IError);

type
  TAPYItem = record
  private
    FReady: Boolean;
    FValue: Double;
    procedure Clear;
    procedure SetValue(aValue: Double);
  public
    property Ready: Boolean read FReady;
    property Value: Double read FValue write SetValue;
  end;

  TAPYCache = record
  private
    C, F, A, D, I, Y2, Y3, V1, V2, R, O, M: TAPYItem;
  public
    procedure Clear;
    procedure Get(client: IWeb3; reserve: TReserve; period: TPeriod; callback: TAsyncAPYs);
  end;

implementation

uses
  // Delphi
  System.Classes,
  System.Math,
  System.SysUtils,
  System.Threading,
  // web3
  web3.eth.aave.v2,
  web3.eth.compound,
  web3.eth.dydx,
  web3.eth.fulcrum,
  web3.eth.idle.finance.v4,
  web3.eth.mstable.save.v2,
  web3.eth.origin.dollar,
  web3.eth.rari.capital.v2,
  web3.eth.yearn.finance.v2,
  web3.eth.yearn.finance.v3,
  web3.eth.yearn.vaults.v1,
  web3.eth.yearn.vaults.v2;

{ TAPYItem }

procedure TAPYItem.Clear;
begin
  Self.FReady := False;
  Self.FValue := 0;
end;

procedure TAPYItem.SetValue(aValue: Double);
begin
  Self.FValue := aValue;
  Self.FReady := True;
end;

{ TAPYCache }

procedure TAPYCache.Clear;
begin
  C.Clear;
  F.Clear;
  A.Clear;
  D.Clear;
  I.Clear;
  Y2.Clear;
  Y3.Clear;
  V1.Clear;
  V2.Clear;
  R.Clear;
  O.Clear;
  M.Clear;
end;

procedure TAPYCache.Get(
  client  : IWeb3;
  reserve : TReserve;
  period  : TPeriod;
  callback: TAsyncAPYs);
type
  PAPYCache = ^TAPYCache;
var
  S: PAPYCache;
begin
  if  (C.Ready)
  and (F.Ready)
  and (A.Ready)
  and (D.Ready)
  and (I.Ready)
  and (Y2.Ready)
  and (Y3.Ready)
  and (V1.Ready)
  and (V2.Ready)
  and (R.Ready)
  and (O.Ready)
  and (M.Ready) then
  begin
    callback(C.Value, F.Value, A.Value, D.Value, I.Value, Y2.Value, Y3.Value, V1.Value, V2.Value, R.Value, O.Value, M.Value, nil);
    EXIT;
  end;

  S := @Self;

  if not TCompound.Supports(client.Chain, reserve) then
    C.Value := -1
  else
    TCompound.APY(client, reserve, period, procedure(value: Double; err: IError)
    begin
      if Assigned(err) then
      begin
        callback(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, err);
        EXIT;
      end;
      if not IsNAN(value) then
        S.C.Value := value
      else
        S.C.Value := -1;
    end);

  if not TFulcrum.Supports(client.Chain, reserve) then
    F.Value := -1
  else
  begin
    TFulcrum.APY(client, reserve, period, procedure(value: Double; err: IError)
    begin
      if Assigned(err) then
      begin
        callback(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, err);
        EXIT;
      end;
      if not IsNAN(value) then
        S.F.Value := value
      else
        S.F.Value := -1;
    end);
  end;

  if not TAave.Supports(client.Chain, reserve) then
    A.Value := -1
  else
    TAave.APY(client, reserve, period, procedure(value: Double; err: IError)
    begin
      if Assigned(err) then
      begin
        callback(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, err);
        EXIT;
      end;
      if not IsNAN(value) then
        S.A.Value := value
      else
        S.A.Value := -1;
    end);

  if not TdYdX.Supports(client.Chain, reserve) then
    D.Value := -1
  else
    TdYdX.APY(client, reserve, period, procedure(value: Double; err: IError)
    begin
      if Assigned(err) then
      begin
        callback(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, err);
        EXIT;
      end;
      if not IsNAN(value) then
        S.D.Value := value
      else
        S.D.Value := -1;
    end);

  if not TIdle.Supports(client.Chain, reserve) then
    I.Value := -1
  else
    TIdle.APY(client, reserve, period, procedure(value: Double; err: IError)
    begin
      if Assigned(err) then
      begin
        callback(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, err);
        EXIT;
      end;
      if not IsNAN(value) then
        S.I.Value := value
      else
        S.I.Value := -1;
    end);

  if not TyEarnV2.Supports(client.Chain, reserve) then
    Y2.Value := -1
  else
    TyEarnV2.APY(client, reserve, period, procedure(value: Double; err: IError)
    begin
      if Assigned(err) then
      begin
        callback(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, err);
        EXIT;
      end;
      if not IsNAN(value) then
        S.Y2.Value := value
      else
        S.Y2.Value := -1;
    end);

  if not TyEarnV3.Supports(client.Chain, reserve) then
    Y3.Value := -1
  else
    TyEarnV3.APY(client, reserve, period, procedure(value: Double; err: IError)
    begin
      if Assigned(err) then
      begin
        callback(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, err);
        EXIT;
      end;
      if not IsNAN(value) then
        S.Y3.Value := value
      else
        S.Y3.Value := -1;
    end);

  if not TyVaultV1.Supports(client.Chain, reserve) then
    V1.Value := -1
  else
    TyVaultV1.APY(client, reserve, period, procedure(value: Double; err: IError)
    begin
      if Assigned(err) then
      begin
        callback(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, err);
        EXIT;
      end;
      if not IsNAN(value) then
        S.V1.Value := value
      else
        S.V1.Value := -1;
    end);

  if not TyVaultV2.Supports(client.Chain, reserve) then
    V2.Value := -1
  else
    TyVaultV2.APY(client, reserve, period, procedure(value: Double; err: IError)
    begin
      if Assigned(err) then
      begin
        callback(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, err);
        EXIT;
      end;
      if not IsNAN(value) then
        S.V2.Value := value
      else
        S.V2.Value := -1;
    end);

  if not TRari.Supports(client.Chain, reserve) then
    R.Value := -1
  else
    TRari.APY(client, reserve, period, procedure(value: Double; err: IError)
    begin
      if Assigned(err) then
      begin
        callback(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, err);
        EXIT;
      end;
      if not IsNAN(value) then
        S.R.Value := value
      else
        S.R.Value := -1;
    end);

  if not TOrigin.Supports(client.Chain, reserve) then
    O.Value := -1
  else
    TOrigin.APY(client, reserve, period, procedure(value: Double; err: IError)
    begin
      if Assigned(err) then
      begin
        callback(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, err);
        EXIT;
      end;
      if not IsNAN(value) then
        S.O.Value := value
      else
        S.O.Value := -1;
    end);

  if not TmStable.Supports(client.Chain, reserve) then
    M.Value := -1
  else
    TmStable.APY(client, reserve, period, procedure(value: Double; err: IError)
    begin
      if Assigned(err) then
      begin
        callback(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, err);
        EXIT;
      end;
      if not IsNAN(value) then
        S.M.Value := value
      else
        S.M.Value := -1;
    end);

  TTask.Create(procedure
  begin
    while TTask.CurrentTask.Status <> TTaskStatus.Canceled do
    begin
      try
        TTask.CurrentTask.Wait(250);
      except end;
      if  (S.C.Ready)
      and (S.F.Ready)
      and (S.A.Ready)
      and (S.D.Ready)
      and (S.I.Ready)
      and (S.Y2.Ready)
      and (S.Y3.Ready)
      and (S.V1.Ready)
      and (S.V2.Ready)
      and (S.R.Ready)
      and (S.O.Ready)
      and (S.M.Ready) then
      begin
        callback(S.C.Value, S.F.Value, S.A.Value, S.D.Value, S.I.Value, S.Y2.Value, S.Y3.Value, S.V1.Value, S.V2.Value, S.R.Value, S.O.Value, S.M.Value, nil);
        EXIT;
      end;
    end;
  end).Start;
end;

end.
