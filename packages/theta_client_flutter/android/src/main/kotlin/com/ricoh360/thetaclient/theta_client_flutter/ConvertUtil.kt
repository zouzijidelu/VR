package com.ricoh360.thetaclient.theta_client_flutter

import com.ricoh360.thetaclient.ThetaRepository.*
import com.ricoh360.thetaclient.capture.Capture
import com.ricoh360.thetaclient.capture.PhotoCapture
import com.ricoh360.thetaclient.capture.VideoCapture
import io.flutter.plugin.common.MethodCall

fun toResult(thetaInfo: ThetaInfo): Map<String, Any> {
    return mapOf<String, Any>(
        "model" to thetaInfo.model,
        "serialNumber" to thetaInfo.serialNumber,
        "firmwareVersion" to thetaInfo.firmwareVersion,
        "hasGps" to thetaInfo.hasGps,
        "hasGyro" to thetaInfo.hasGyro,
        "uptime" to thetaInfo.uptime
    )
}

fun toResult(thetaState: ThetaState): Map<String, Any> {
    return mapOf<String, Any>(
        "fingerprint" to thetaState.fingerprint,
        "batteryLevel" to thetaState.batteryLevel,
        "chargingState" to thetaState.chargingState.name,
        "isSdCard" to thetaState.isSdCard,
        "recordedTime" to thetaState.recordedTime,
        "recordableTime" to thetaState.recordableTime,
        "latestFileUrl" to thetaState.latestFileUrl
    )
}

fun toResult(fileInfoList: List<FileInfo>): List<Map<String, Any>> {
    val result = mutableListOf<Map<String, Any>>()
    fileInfoList.forEach {
        val map = mapOf<String, Any>(
            "name" to it.name,
            "size" to it.size,
            "dateTime" to it.dateTime,
            "fileUrl" to it.fileUrl,
            "thumbnailUrl" to it.thumbnailUrl
        )
        result.add(map)
    }
    return result
}

fun toGpsInfo(map: Map<String, Any>): GpsInfo {
    return GpsInfo(
        latitude = (map["latitude"] as Double).toFloat(),
        longitude = (map["longitude"] as Double).toFloat(),
        altitude = (map["altitude"] as Double).toFloat(),
        dateTimeZone = map["dateTimeZone"] as String
    )
}

fun <T>setCaptureBuilderParams(call: MethodCall, builder: Capture.Builder<T>) {
    call.argument<String>(OptionNameEnum.Aperture.name)?.also { enumName ->
        ApertureEnum.values().find { it.name == enumName }?.let {
            builder.setAperture(it)
        }
    }
    call.argument<Int>(OptionNameEnum.ColorTemperature.name)?.also {
        builder.setColorTemperature(it)
    }
    call.argument<String>(OptionNameEnum.ExposureDelay.name)?.also { enumName ->
        ExposureDelayEnum.values().find { it.name == enumName }?.let {
            builder.setExposureDelay(it)
        }
    }
    call.argument<String>(OptionNameEnum.ExposureProgram.name)?.also { enumName ->
        ExposureProgramEnum.values().find { it.name == enumName }?.let {
            builder.setExposureProgram(it)
        }
    }
    call.argument<Map<String, Any>>(OptionNameEnum.GpsInfo.name)?.also {
        builder.setGpsInfo(toGpsInfo(it))
    }
    call.argument<String>("GpsTagRecording")?.also { enumName ->
        GpsTagRecordingEnum.values().find { it.name == enumName }?.let {
            builder.setGpsTagRecording(it)
        }
    }
    call.argument<String>(OptionNameEnum.Iso.name)?.also { enumName ->
        IsoEnum.values().find { it.name == enumName }?.let {
            builder.setIso(it)
        }
    }
    call.argument<String>(OptionNameEnum.IsoAutoHighLimit.name)?.also { enumName ->
        IsoAutoHighLimitEnum.values().find { it.name == enumName }?.let {
            builder.setIsoAutoHighLimit(it)
        }
    }
    call.argument<String>(OptionNameEnum.WhiteBalance.name)?.also { enumName ->
        WhiteBalanceEnum.values().find { it.name == enumName }?.let {
            builder.setWhiteBalance(it)
        }
    }
}

fun setPhotoCaptureBuilderParams(call: MethodCall, builder: PhotoCapture.Builder) {
    call.argument<String>(OptionNameEnum.Filter.name)?.let { enumName ->
        FilterEnum.values().find { it.name == enumName }?.let {
            builder.setFilter(it)
        }
    }
    call.argument<String>("PhotoFileFormat")?.let { enumName ->
        PhotoFileFormatEnum.values().find { it.name == enumName }?.let {
            builder.setFileFormat(it)
        }
    }
}

fun setVideoCaptureBuilderParams(call: MethodCall, builder: VideoCapture.Builder) {
    call.argument<String>(OptionNameEnum.MaxRecordableTime.name)?.let { enumName ->
        MaxRecordableTimeEnum.values().find { it.name == enumName }?.let {
            builder.setMaxRecordableTime(it)
        }
    }
    call.argument<String>("VideoFileFormat")?.let { enumName ->
        VideoFileFormatEnum.values().find { it.name == enumName }?.let {
            builder.setFileFormat(it)
        }
    }
}

fun toGetOptionsParam(data: List<String>): List<OptionNameEnum> {
    val optionNames = mutableListOf<OptionNameEnum>()
    data.forEach { name ->
        OptionNameEnum.values().find { it.name == name }?.let {
            optionNames.add(it)
        }
    }
    return optionNames
}

fun toResult(gpsInfo: GpsInfo): Map<String, Any> {
    return mapOf(
        "latitude" to gpsInfo.latitude,
        "longitude" to gpsInfo.longitude,
        "altitude" to gpsInfo.altitude,
        "dateTimeZone" to gpsInfo.dateTimeZone
    )
}

fun toResult(options: Options): Map<String, Any> {
    val result = mutableMapOf<String, Any>()

    val valueOptions = listOf(
        OptionNameEnum.ColorTemperature,
        OptionNameEnum.DateTimeZone,
        OptionNameEnum.IsGpsOn,
        OptionNameEnum.RemainingPictures,
        OptionNameEnum.RemainingVideoSeconds,
        OptionNameEnum.RemainingSpace,
        OptionNameEnum.TotalSpace,
        OptionNameEnum.ShutterVolume
    )
    OptionNameEnum.values().forEach { name ->
        if (name == OptionNameEnum.GpsInfo) {
            options.getValue<GpsInfo>(OptionNameEnum.GpsInfo)?.let { gpsInfo ->
                result[OptionNameEnum.GpsInfo.name] = toResult(gpsInfo)
            }
        } else if (valueOptions.contains(name)) {
            addOptionsValueToMap<Any>(options, name, result)
        } else {
            addOptionsEnumToMap(options, name, result)
        }
    }
    return result
}

fun <T : Enum<T>>addOptionsEnumToMap(options: Options, name: OptionNameEnum, map: MutableMap<String, Any>) {
    options.getValue<T>(name)?.let {
        map[name.name] = it.name
    }
}

fun <T>addOptionsValueToMap(options: Options, name: OptionNameEnum, map: MutableMap<String, Any>) {
    options.getValue<T>(name)?.let {
        map[name.name] = it
    }
}

fun toSetOptionsParam(data: Map<String, Any>): Options {
    val options = Options()
    data.forEach { (key, value) ->
        OptionNameEnum.values().find { it.name == key }?.let {
            setOptionValue(options, it, value)
        }
    }
    return options
}

fun setOptionValue(options: Options, name: OptionNameEnum, value: Any) {
    val valueOptions = listOf(
        OptionNameEnum.ColorTemperature,
        OptionNameEnum.DateTimeZone,
        OptionNameEnum.IsGpsOn,
        OptionNameEnum.RemainingPictures,
        OptionNameEnum.RemainingVideoSeconds,
        OptionNameEnum.RemainingSpace,
        OptionNameEnum.TotalSpace,
        OptionNameEnum.ShutterVolume
    )
    if (valueOptions.contains(name)) {
        var optionValue = value
        if (name.valueType == Long::class && value is Int) {
            optionValue = value.toLong()
        }
        options.setValue(name, optionValue)
    } else if (name == OptionNameEnum.GpsInfo) {
        @Suppress("UNCHECKED_CAST")
        options.setValue(name, toGpsInfo(value as Map<String, Any>))
    } else {
        getOptionValueEnum(name, value as String)?.let {
            options.setValue(name, it)
        }
    }
}

fun getOptionValueEnum(name: OptionNameEnum, valueName: String): Any? {
    return when (name) {
        OptionNameEnum.Aperture -> ApertureEnum.values().find { it.name == valueName }
        OptionNameEnum.CaptureMode -> CaptureModeEnum.values().find { it.name == valueName }
        OptionNameEnum.ExposureCompensation -> ExposureCompensationEnum.values().find { it.name == valueName }
        OptionNameEnum.ExposureDelay -> ExposureDelayEnum.values().find { it.name == valueName }
        OptionNameEnum.ExposureProgram -> ExposureProgramEnum.values().find { it.name == valueName }
        OptionNameEnum.FileFormat -> FileFormatEnum.values().find { it.name == valueName }
        OptionNameEnum.Filter -> FilterEnum.values().find { it.name == valueName }
        OptionNameEnum.Iso -> IsoEnum.values().find { it.name == valueName }
        OptionNameEnum.IsoAutoHighLimit -> ApertureEnum.values().find { it.name == valueName }
        OptionNameEnum.Language -> LanguageEnum.values().find { it.name == valueName }
        OptionNameEnum.MaxRecordableTime -> MaxRecordableTimeEnum.values().find { it.name == valueName }
        OptionNameEnum.OffDelay -> OffDelayEnum.values().find { it.name == valueName }
        OptionNameEnum.SleepDelay -> SleepDelayEnum.values().find { it.name == valueName }
        OptionNameEnum.WhiteBalance -> WhiteBalanceEnum.values().find { it.name == valueName }
        else -> null
    }
}

fun toConfigParam(data: Map<String, Any>): Config {
    val config = Config()
    data.forEach { (key, value) ->
        when (key) {
            OptionNameEnum.DateTimeZone.name -> config.dateTime = value.toString()
            OptionNameEnum.Language.name -> config.language =
                getOptionValueEnum(OptionNameEnum.Language, value as String) as LanguageEnum?
            OptionNameEnum.OffDelay.name -> config.offDelay =
                getOptionValueEnum(OptionNameEnum.OffDelay, value as String) as OffDelayEnum?
            OptionNameEnum.SleepDelay.name -> config.sleepDelay =
                getOptionValueEnum(OptionNameEnum.SleepDelay, value as String) as SleepDelayEnum?
            OptionNameEnum.ShutterVolume.name -> config.shutterVolume = value as Int
        }
    }
    return config
}

fun toTimeoutParam(map: Map<String, Any>): Timeout {
    return Timeout(
        connectTimeout = map["connectTimeout"]!!.let { (it as Number).toLong() },
        requestTimeout = map["requestTimeout"]!!.let { (it as Number).toLong() },
        socketTimeout = map["socketTimeout"]!!.let { (it as Number).toLong() }
    )
}

fun toResult(exif: Exif): Map<String, Any> {
    val result = mutableMapOf<String, Any>()
    result["exifVersion"] = exif.exifVersion
    result["dateTime"] = exif.dateTime
    exif.imageWidth?.let {
        result["imageWidth"] = it
    }
    exif.imageLength?.let {
        result["imageLength"] = it
    }
    exif.gpsLatitude?.let {
        result["gpsLatitude"] = it
    }
    exif.gpsLongitude?.let {
        result["gpsLongitude"] = it
    }
    return result
}

fun toResult(xmp: Xmp): Map<String, Any> {
    val result = mutableMapOf<String, Any>()
    result["fullPanoWidthPixels"] = xmp.fullPanoWidthPixels
    result["fullPanoHeightPixels"] = xmp.fullPanoHeightPixels
    xmp.poseHeadingDegrees?.let {
        result["poseHeadingDegrees"] = it
    }
    return result
}

fun toResult(metadata: Pair<Exif, Xmp>): Map<String, Any> {
    return mapOf<String, Any>(
        "exif" to toResult(metadata.first),
        "xmp" to toResult(metadata.second),
    )
}

fun toListAccessPointsResult(accessPointList: List<AccessPoint>): List<Map<String, Any>> {
    val resultList = mutableListOf<Map<String, Any>>()
    accessPointList.forEach { accessPoint ->
        val result = mutableMapOf<String, Any>()
        result["ssid"] = accessPoint.ssid
        result["ssidStealth"] = accessPoint.ssidStealth
        result["authMode"] = accessPoint.authMode.name
        result["connectionPriority"] = accessPoint.connectionPriority
        result["usingDhcp"] = accessPoint.usingDhcp
        accessPoint.ipAddress?.let {
            result["ipAddress"] = it
        }
        accessPoint.subnetMask?.let {
            result["subnetMask"] = it
        }
        accessPoint.defaultGateway?.let {
            result["defaultGateway"] = it
        }
        resultList.add(result)
    }
    return resultList
}
