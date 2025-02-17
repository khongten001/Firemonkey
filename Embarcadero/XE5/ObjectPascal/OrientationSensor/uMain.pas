unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.Sensors, FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Sensors, FMX.ListBox, FMX.Layouts, FMX.MobilePreview;

type
  TOrientationSensorForm = class(TForm)
    OrientationSensor1: TOrientationSensor;
    swOrientationSensorActive: TSwitch;
    ToolBar1: TToolBar;
    Label1: TLabel;
    ListBox1: TListBox;
    lbOrientationSensor: TListBoxItem;
    lbTiltX: TListBoxItem;
    lbTiltY: TListBoxItem;
    lbTiltZ: TListBoxItem;
    lbHeadingX: TListBoxItem;
    lbHeadingY: TListBoxItem;
    lbHeadingZ: TListBoxItem;
    Layout1: TLayout;
    TiltButton: TSpeedButton;
    HeadingButton: TSpeedButton;
    procedure OrientationSensor1DataChanged(Sender: TObject);
    procedure swOrientationSensorActiveSwitch(Sender: TObject);
    procedure OrientationSensor1SensorChoosing(Sender: TObject;
      const Sensors: TSensorArray; var ChoseSensorIndex: Integer);
    procedure TiltButtonClick(Sender: TObject);
    procedure HeadingButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OrientationSensorForm: TOrientationSensorForm;

implementation

{$R *.fmx}

procedure TOrientationSensorForm.OrientationSensor1DataChanged(Sender: TObject);
begin
  { get the data from the sensor }
  lbTiltX.Text := Format('Tilt X: %f', [OrientationSensor1.Sensor.TiltX]);
  lbTiltY.Text := Format('Tilt Y: %f', [OrientationSensor1.Sensor.TiltY]);
  lbTiltZ.Text := Format('Tilt Z: %f', [OrientationSensor1.Sensor.TiltZ]);
  lbHeadingX.Text := Format('Heading X: %f', [OrientationSensor1.Sensor.HeadingX]);
  lbHeadingY.Text := Format('Heading Y: %f', [OrientationSensor1.Sensor.HeadingY]);
  lbHeadingZ.Text := Format('Heading Z: %f', [OrientationSensor1.Sensor.HeadingZ]);
end;

procedure TOrientationSensorForm.OrientationSensor1SensorChoosing(
  Sender: TObject; const Sensors: TSensorArray; var ChoseSensorIndex: Integer);
var
  I: Integer;
  Found: Integer;
begin
  Found := -1;
  for I := 0 to High(Sensors) do
  begin
    if TiltButton.IsPressed and (TCustomOrientationSensor.TProperty.TiltX in TCustomOrientationSensor(Sensors[I]).AvailableProperties) then
    begin
        Found := I;
        Break;
    end
    else if HeadingButton.IsPressed and (TCustomOrientationSensor.TProperty.HeadingX in TCustomOrientationSensor(Sensors[I]).AvailableProperties) then
    begin
      Found := I;
      Break;
    end;
  end;

  if Found < 0 then
  begin
    Found := 0;
    TiltButton.IsPressed := True;
    HeadingButton.IsPressed := False;
    ShowMessage('Compass not available');
  end;

  ChoseSensorIndex := Found;
end;

procedure TOrientationSensorForm.TiltButtonClick(Sender: TObject);
begin
  OrientationSensor1.Active := False;
  HeadingButton.IsPressed := False;
  TiltButton.IsPressed := True;
  OrientationSensor1.Active := swOrientationSensorActive.IsChecked;
end;

procedure TOrientationSensorForm.FormActivate(Sender: TObject);
begin
{$ifdef IOS}
  {$ifndef CPUARM}
    lbOrientationSensor.Text := 'Simulator - no sensors';
    swOrientationSensorActive.Enabled := False;
  {$endif}
{$endif}
end;

procedure TOrientationSensorForm.HeadingButtonClick(Sender: TObject);
begin
  OrientationSensor1.Active := False;
  TiltButton.IsPressed := False;
  HeadingButton.IsPressed := True;
  OrientationSensor1.Active := swOrientationSensorActive.IsChecked;
end;

procedure TOrientationSensorForm.swOrientationSensorActiveSwitch(
  Sender: TObject);
begin
  { activate or deactivate the orientation sensor }
  OrientationSensor1.Active := swOrientationSensorActive.IsChecked;
end;

end.
