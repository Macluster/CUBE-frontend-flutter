// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import 'package:shopos/src/pages/billing_list.dart';
import 'package:shopos/src/pages/checkout.dart';

class CombineArgs {
  BluetoothArgs? bluetoothArgs;
  PrintBillArgs? billArgs;
  CombineArgs({
    this.bluetoothArgs,
    this.billArgs,
  });
}

class BluetoothPrinterList extends StatefulWidget {
  static const routeName = '/bluetooth-printers';
  BluetoothPrinterList({Key? key, required this.args}) : super(key: key);

  final CombineArgs args;

  @override
  State<BluetoothPrinterList> createState() => _BluetoothPrinterListState();
}

class _BluetoothPrinterListState extends State<BluetoothPrinterList> {
  // List<BluetoothDevice> _devices = [];
  List<BluetoothInfo> _devices = [];
  String _deviceMsg = "";

  @override
  void initState() {
    super.initState();
    getpermission();
    getDevices();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   initPrinter();
    // });
    // Timer.periodic(Duration(seconds: 10), (timer) {
    //   initPrinter();
    // });
  }

  getDevices() async {
    final bool result = await PrintBluetoothThermal.bluetoothEnabled;
    _devices = await PrintBluetoothThermal.pairedBluetooths;
    await Future.forEach(_devices, (BluetoothInfo bluetooth) {
      String name = bluetooth.name;
      String mac = bluetooth.macAdress;
    });
    setState(() {});
  }

  // Future<void> initPrinter() async {
  //   await bluetoothPrint.startScan(timeout: Duration(seconds: 5));
  //   if (!mounted) return;
  //   bluetoothPrint.scanResults.listen((val) {
  //     if (!mounted) return;
  //     print(val);
  //     setState(() {
  //       _devices = val;
  //       if (_devices.isEmpty) {
  //         _deviceMsg = "No devices found";
  //       }
  //     });
  //   });
  //   await bluetoothPrint.stopScan();
  // }

  void getpermission() async {
    try {
      await Permission.bluetoothScan.request();
      if (await Permission.bluetoothScan.isDenied) {
        Navigator.of(context).pop();
      }

      await Permission.bluetoothAdvertise.request();

      await Permission.ignoreBatteryOptimizations;

      if (await Permission.bluetooth.request().isDenied) {
        Navigator.of(context).pop();
      }

      await Permission.bluetoothConnect.request();
      if (await Permission.bluetooth.status.isDenied) {
        Navigator.of(context).pop();
      }

      await Permission.locationWhenInUse.request();
      if (await Permission.location.status.isDenied) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // Future<void> getBluetooth() async {
  //   final List bluetooths = await BluetoothThermalPrinter.getBluetooths ?? [];
  //   if (!mounted) return;
  //   print("Print ${bluetooths}");
  //   setState(() {
  //     if (!mounted) return;
  //     _devices = bluetooths;
  //     if (_devices.isEmpty) {
  //       _deviceMsg = "No devices found";
  //     }
  //   });
  // }

  // Function to print PDF via Bluetooth
  // Future<void> printPdfViaBluetooth(BluetoothDevice device) async {
  //   if (device != null && device.address != null) {
  //     var isconnect = await bluetoothPrint.connect(device);
  //     print(device);
  //     print(isconnect);

  //     String dateFormat() => DateFormat('MMM d, y hh:mm:ss a')
  //         .format(widget.bluetoothArgs.dateTime);

  //     Map<String, dynamic> config = Map();
  //     List<LineText> list = [];

  //     list.add(LineText(
  //       type: LineText.TYPE_TEXT,
  //       content: "KOT",
  //       weight: 2,
  //       width: 2,
  //       height: 2,
  //       align: LineText.ALIGN_CENTER,
  //       linefeed: 1,
  //     ));

  //     list.add(LineText(
  //       type: LineText.TYPE_TEXT,
  //       content: dateFormat(),
  //       weight: 1,
  //       align: LineText.ALIGN_CENTER,
  //       linefeed: 1,
  //     ));

  //     list.add(LineText(
  //       type: LineText.TYPE_TEXT,
  //       content: 'Table',
  //       weight: 1,
  //       width: 2,
  //       height: 2,
  //       align: LineText.ALIGN_CENTER,
  //       linefeed: 1,
  //     ));

  //     list.add(LineText(
  //       content: 'Item',
  //       type: LineText.TYPE_TEXT,
  //       weight: 0,
  //       align: LineText.ALIGN_LEFT,
  //     ));

  //     list.add(LineText(
  //       content: 'Qty',
  //       type: LineText.TYPE_TEXT,
  //       weight: 0,
  //       align: LineText.ALIGN_RIGHT,
  //       linefeed: 1,
  //     ));

  //     for (var i = 0;
  //         i < widget.bluetoothArgs.orderInput.orderItems!.length;
  //         i++) {
  //       list.add(LineText(
  //         content: widget.bluetoothArgs.orderInput.orderItems![i].product!.name,
  //         type: LineText.TYPE_TEXT,
  //         weight: 0,
  //         align: LineText.ALIGN_LEFT,
  //       ));

  //       list.add(LineText(
  //         content: widget.bluetoothArgs.orderInput.orderItems![i].quantity
  //             .toString(),
  //         type: LineText.TYPE_TEXT,
  //         weight: 0,
  //         align: LineText.ALIGN_RIGHT,
  //         linefeed: 1,
  //       ));
  //     }

  //     // if (device.connected == null) {
  //     //   await bluetoothPrint.connect(device);
  //     // }
  //     print('0=${device.address}');
  //     print(isconnect);

  //     // await bluetoothPrint.printLabel(config, list);
  //     // await bluetoothPrint.disconnect();

  //     bluetoothPrint.state.listen((event) async {
  //       print(BluetoothPrint.CONNECTED);
  //       print(BluetoothPrint.DISCONNECTED);
  //       print(BluetoothPrint.NAMESPACE);
  //       print(isconnect);
  //       print(event);
  //       switch (event) {
  //         case BluetoothPrint.CONNECTED:
  //           print(BluetoothPrint.CONNECTED);
  //           await bluetoothPrint.printReceipt(config, list);
  //         // await bluetoothPrint.disconnect();
  //       }
  //     });
  //   }
  // }

  Future<void> printKot(String mac) async {
    final bool result =
        await PrintBluetoothThermal.connect(macPrinterAddress: mac);
    bool conecctionStatus = await PrintBluetoothThermal.connectionStatus;
    if (conecctionStatus) {
      List<int> ticket = await kotTicket();
      final result = await PrintBluetoothThermal.writeBytes(ticket);
      print("print result: $result");
    } else {
      //no connected
    }
  }

  Future<List<int>> kotTicket() async {
    final bargs = widget.args.bluetoothArgs!;
    List<int> bytes = [];
    // Using default profile
    final profile = await CapabilityProfile.load();
    final generator = Generator(
        bargs.type == kotType.is57mm ? PaperSize.mm58 : PaperSize.mm80,
        profile);
    //bytes += generator.setGlobalFont(PosFontType.fontA);
    bytes += generator.reset();

    // Using `ESC *`

    String dateFormat() =>
        DateFormat('MMM d, y hh:mm:ss a').format(bargs.dateTime);

    // print an image

//     final ByteData data = await rootBundle.load('assets/logo.png');
//     final Uint8List bytes = data.buffer.asUint8List();
//     final Image image = decodeImage(bytes);
// // Using `ESC *`
//     generator.image(image);
// // Using `GS v 0` (obsolete)
//     generator.imageRaster(image);
// // Using `GS ( L`
//     generator.imageRaster(image, imageFn: PosImageFn.graphics);

    bytes += generator.text('KOT',
        styles: PosStyles(fontType: PosFontType.fontA, align: PosAlign.center));
    bytes += generator.text(dateFormat(),
        styles: PosStyles(fontType: PosFontType.fontA, align: PosAlign.center));
    bytes += generator.text(
      'Table',
      styles: PosStyles(fontType: PosFontType.fontA, align: PosAlign.center),
      linesAfter: 2,
    );
    // bytes +=
    //     generator.text('Align left', styles: PosStyles(align: PosAlign.left));
    // bytes += generator.text('Align center',
    //     styles: PosStyles(align: PosAlign.center));
    // bytes += generator.text('Align right',
    //     styles: PosStyles(align: PosAlign.right), linesAfter: 1);

    bytes += generator.row([
      PosColumn(
        text: 'item',
        width: 9,
        styles: PosStyles(bold: true, height: PosTextSize.size1),
      ),
      PosColumn(
        text: 'Qty',
        width: 3,
        styles: PosStyles(bold: true, height: PosTextSize.size1),
      ),
      // PosColumn(
      //   text: 'col3',
      //   width: 3,
      //   styles: PosStyles(align: PosAlign.center, underline: true),
      // ),
    ]);

    for (int i = 0; i < bargs.orderInput.orderItems!.length; i++) {
      bytes += generator.row([
        PosColumn(
          text: '${bargs.orderInput.orderItems![i].product!.name}',
          width: 9,
          styles: PosStyles(height: PosTextSize.size1),
        ),
        PosColumn(
          text: '${bargs.orderInput.orderItems![i].quantity}',
          width: 3,
          styles: PosStyles(height: PosTextSize.size1),
        ),
      ]);
    }

    //barcode
    // final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    // bytes += generator.barcode(Barcode.upcA(barData));

    //QR code
    // bytes += generator.qrcode('example.com');

    // bytes += generator.text(
    //   'Text size 50%',
    //   styles: PosStyles(
    //     fontType: PosFontType.fontB,
    //   ),
    // );
    // bytes += generator.text(
    //   'Text size 100%',
    //   styles: PosStyles(
    //     fontType: PosFontType.fontA,
    //   ),
    // );
    // bytes += generator.text(
    //   'Text size 200%',
    //   styles: PosStyles(
    //     height: PosTextSize.size2,
    //     width: PosTextSize.size2,
    //   ),
    // );

    bytes += generator.feed(2);
    bytes += generator.cut();
    return bytes;
  }

  Future<void> printbill(String mac) async {
    print(widget.args.billArgs!.subtotalPrice);
    print(widget.args.billArgs!.gsttotalPrice);
    print(widget
        .args.billArgs!.order.orderItems![0].product!.baseSellingPriceGst);
    final bool result =
        await PrintBluetoothThermal.connect(macPrinterAddress: mac);
    bool conecctionStatus = await PrintBluetoothThermal.connectionStatus;
    if (conecctionStatus) {
      List<int> ticket = await billTicket();
      final result = await PrintBluetoothThermal.writeBytes(ticket);
      print("print result: $result");
    } else {
      //no connected
    }
  }

  Future<List<int>> billTicket() async {
    final args = widget.args.billArgs!;

    List<int> bytes = [];
    // Using default profile
    final profile = await CapabilityProfile.load();
    final generator = Generator(
        args.type == billType.is57mm ? PaperSize.mm58 : PaperSize.mm80,
        profile);
    //bytes += generator.setGlobalFont(PosFontType.fontA);
    bytes += generator.reset();

    // Using `ESC *`

    String dateFormat() => DateFormat('dd/MM/yy').format(args.dateTime);

    List<String>? addressRows() => args.user.address
        ?.toString()
        .split(',')
        .map((e) =>
            '${e.replaceAll('{', '').replaceAll('}', '').replaceAll('[', '').replaceAll(']', '').replaceAll(',', '').replaceAll('locality:', '').replaceAll('city:', '').replaceAll('state:', '').replaceAll('country:', '')}')
        .toList();

    bytes += generator.text('${args.user.businessName}',
        styles: PosStyles(height: PosTextSize.size5, align: PosAlign.center));

    for (int i = 0; i < addressRows()!.length; i++) {
      bytes += generator.text('${addressRows()!.elementAt(i)}',
          styles: PosStyles(height: PosTextSize.size1, align: PosAlign.center));
    }
    bytes += generator.text('${args.user.phoneNumber}',
        styles: PosStyles(height: PosTextSize.size1, align: PosAlign.center));

    bytes += generator.row([
      PosColumn(
        text: 'Invoice ${args.invoiceNum}',
        width: 8,
        styles: PosStyles(height: PosTextSize.size1),
      ),
      PosColumn(
        text: '${dateFormat()}',
        width: 4,
        styles: PosStyles(height: PosTextSize.size1),
      ),
    ]);

    bytes += generator.text(
      '${args.invoiceNum.substring(8, 10)}:${args.invoiceNum.substring(10, 12)}',
      styles: PosStyles(fontType: PosFontType.fontA, align: PosAlign.right),
      linesAfter: 2,
    );

    for (int i = 0; i < args.order.orderItems!.length; i++) {
      bytes += generator.row([
        PosColumn(
          text:
              '${args.order.orderItems![i].quantity}  ${args.order.orderItems![i].product!.name}',
          width: 9,
          styles: PosStyles(
            height: PosTextSize.size1,
            underline: true,
          ),
        ),
        PosColumn(
          text:
              ' ${args.order.orderItems![i].product!.baseSellingPriceGst == 'null' ? args.order.orderItems![i].product!.sellingPrice : args.order.orderItems![i].product!.baseSellingPriceGst}  ',
          width: 3,
          styles: PosStyles(height: PosTextSize.size1),
        ),
      ]);
    }

    bytes += generator.hr(linesAfter: 1);

    bytes += generator.row([
      PosColumn(
        text: 'Subtotal',
        width: 6,
        styles: PosStyles(height: PosTextSize.size1),
      ),
      PosColumn(
        text: ' ${args.subtotalPrice}',
        width: 6,
        styles: PosStyles(height: PosTextSize.size1),
      ),
    ]);

    bytes += generator.row([
      PosColumn(
        text: 'GST',
        width: 6,
        styles: PosStyles(height: PosTextSize.size1),
      ),
      PosColumn(
        text: ' ${args.gsttotalPrice}',
        width: 6,
        styles: PosStyles(height: PosTextSize.size1),
      ),
    ]);

    bytes += generator.hr(linesAfter: 1);

    bytes += generator.row([
      PosColumn(
        text: 'Grand Total',
        width: 6,
        styles: PosStyles(height: PosTextSize.size1),
      ),
      PosColumn(
        text: ' ${args.totalPrice}',
        width: 6,
        styles: PosStyles(height: PosTextSize.size1),
      ),
    ]);

    bytes += generator.hr(linesAfter: 1);

    bytes += generator.text('Thank you and see you again',
        styles: PosStyles(align: PosAlign.center, fontType: PosFontType.fontB));

    //barcode
    // final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    // bytes += generator.barcode(Barcode.upcA(barData));

    //QR code
    // bytes += generator.qrcode('example.com');

    // bytes += generator.feed(2);
    bytes += generator.cut();
    return bytes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Printer page"),
        ),
        backgroundColor: Colors.white,
        body: _devices.isNotEmpty
            ? ListView.builder(
                itemBuilder: (context, position) {
                  return ListTile(
                    onTap: () async {
                      // printPdfViaBluetooth(_devices[position]);
                      // printkot(_devices[position].macAdress);
                      if (widget.args.bluetoothArgs != null &&
                          widget.args.billArgs == null) {
                        printKot(_devices[position].macAdress);
                      } else if (widget.args.billArgs != null &&
                          widget.args.bluetoothArgs == null) {
                        print('ok');
                        printbill(_devices[position].macAdress);
                      }
                    },
                    leading: Icon(Icons.print),
                    title: Text(_devices[position].name),
                    subtitle: Text(_devices[position].macAdress),
                  );
                },
                itemCount: _devices.length,
              )
            : Center(
                child: Text(
                  _deviceMsg ?? 'Ops something went wrong!',
                  style: TextStyle(fontSize: 24),
                ),
              ));
  }
}
