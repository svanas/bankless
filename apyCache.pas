unit apyCache;

interface

uses
  // web3
  web3,
  web3.eth.defi;

type
  TAsyncAPYs = reference to procedure(C, F, A, D, I, Y2, Y3, V1, V2, R, O, M: Extended);

  TAPYCache = record
  private
    C, F, A, D, I, Y2, Y3, V1, V2, R, O, M: Extended;
  public
    procedure Clear;
    procedure Get(client: TWeb3; reserve: TReserve; period: TPeriod; callback: TAsyncAPYs);
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

procedure TAPYCache.Clear;
begin
  C  := 0;
  F  := 0;
  A  := 0;
  D  := 0;
  I  := 0;
  Y2 := 0;
  Y3 := 0;
  V1 := 0;
  V2 := 0;
  R  := 0;
  O  := 0;
  M  := 0;
end;

procedure TAPYCache.Get(
  client  : TWeb3;
  reserve : TReserve;
  period  : TPeriod;
  callback: TAsyncAPYs);
type
  PAPYCache = ^TAPYCache;
var
  S: PAPYCache;
begin
  if  (C  <> 0)
  and (F  <> 0)
  and (A  <> 0)
  and (D  <> 0)
  and (I  <> 0)
  and (Y2 <> 0)
  and (Y3 <> 0)
  and (V1 <> 0)
  and (V2 <> 0)
  and (R  <> 0)
  and (O  <> 0)
  and (M  <> 0) then
  begin
    callback(C, F, A, D, I, Y2, Y3, V1, V2, R, O, M);
    EXIT;
  end;

  S := @Self;

  if not TCompound.Supports(client.Chain, reserve) then
    C := -1
  else
    TCompound.APY(client, reserve, period, procedure(value: Extended; err: IError)
    begin
      if (value <> 0) and (not IsNAN(value)) then
        S.C := value
      else
        S.C := -1;
    end);

  if not TFulcrum.Supports(client.Chain, reserve) then
    F := -1
  else
  begin
    TFulcrum.APY(client, reserve, period, procedure(value: Extended; err: IError)
    begin
      if (value <> 0) and (not IsNAN(value)) then
        S.F := value
      else
        S.F := -1;
    end);
  end;

  if not TAave.Supports(client.Chain, reserve) then
    A := -1
  else
    TAave.APY(client, reserve, period, procedure(value: Extended; err: IError)
    begin
      if (value <> 0) and (not IsNAN(value)) then
        S.A := value
      else
        S.A := -1;
    end);

  if not TdYdX.Supports(client.Chain, reserve) then
    D := -1
  else
    TdYdX.APY(client, reserve, period, procedure(value: Extended; err: IError)
    begin
      if (value <> 0) and (not IsNAN(value)) then
        S.D := value
      else
        S.D := -1;
    end);

  if not TIdle.Supports(client.Chain, reserve) then
    I := -1
  else
    TIdle.APY(client, reserve, period, procedure(value: Extended; err: IError)
    begin
      if (value <> 0) and (not IsNAN(value)) then
        S.I := value
      else
        S.I := -1;
    end);

  if not TyEarnV2.Supports(client.Chain, reserve) then
    Y2 := -1
  else
    TyEarnV2.APY(client, reserve, period, procedure(value: Extended; err: IError)
    begin
      if (value <> 0) and (not IsNAN(value)) then
        S.Y2 := value
      else
        S.Y2 := -1;
    end);

  if not TyEarnV3.Supports(client.Chain, reserve) then
    Y3 := -1
  else
    TyEarnV3.APY(client, reserve, period, procedure(value: Extended; err: IError)
    begin
      if (value <> 0) and (not IsNAN(value)) then
        S.Y3 := value
      else
        S.Y3 := -1;
    end);

  if not TyVaultV1.Supports(client.Chain, reserve) then
    V1 := -1
  else
    TyVaultV1.APY(client, reserve, period, procedure(value: Extended; err: IError)
    begin
      if (value <> 0) and (not IsNAN(value)) then
        S.V1 := value
      else
        S.V1 := -1;
    end);

  if not TyVaultV2.Supports(client.Chain, reserve) then
    V2 := -1
  else
    TyVaultV2.APY(client, reserve, period, procedure(value: Extended; err: IError)
    begin
      if (value <> 0) and (not IsNAN(value)) then
        S.V2 := value
      else
        S.V2 := -1;
    end);

  if not TRari.Supports(client.Chain, reserve) then
    R := -1
  else
    TRari.APY(client, reserve, period, procedure(value: Extended; err: IError)
    begin
      if (value <> 0) and (not IsNAN(value)) then
        S.R := value
      else
        S.R := -1;
    end);

  if not TOrigin.Supports(client.Chain, reserve) then
    O := -1
  else
    TOrigin.APY(client, reserve, period, procedure(value: Extended; err: IError)
    begin
      if (value <> 0) and (not IsNAN(value)) then
        S.O := value
      else
        S.O := -1;
    end);

  if not TmStable.Supports(client.Chain, reserve) then
    M := -1
  else
    TmStable.APY(client, reserve, period, procedure(value: Extended; err: IError)
    begin
      if (value <> 0) and (not IsNAN(value)) then
        S.M := value
      else
        S.M := -1;
    end);

  TTask.Create(procedure
  begin
    while TTask.CurrentTask.Status <> TTaskStatus.Canceled do
    begin
      try
        TTask.CurrentTask.Wait(250);
      except end;
      if  (S.C  <> 0)
      and (S.F  <> 0)
      and (S.A  <> 0)
      and (S.D  <> 0)
      and (S.I  <> 0)
      and (S.Y2 <> 0)
      and (S.Y3 <> 0)
      and (S.V1 <> 0)
      and (S.V2 <> 0)
      and (S.R  <> 0)
      and (S.O  <> 0)
      and (S.M  <> 0) then
      begin
        callback(S.C, S.F, S.A, S.D, S.I, S.Y2, S.Y3, S.V1, S.V2, S.R, S.O, S.M);
        EXIT;
      end;
    end;
  end).Start;
end;

end.
