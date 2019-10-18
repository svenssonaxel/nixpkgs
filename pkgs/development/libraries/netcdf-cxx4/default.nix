{ lib, stdenv, fetchzip, netcdf, hdf5, curl }:
stdenv.mkDerivation rec {
  pname = "netcdf-cxx4";
  version = "4.3.1";

  src = fetchzip {
    url = "https://github.com/Unidata/netcdf-cxx4/archive/v${version}.tar.gz";
    sha256 = "05kydd5z9iil5iv4fp7l11cicda5n5lsg5sdmsmc55xpspnsg7hr";
  };

  buildInputs = [ netcdf hdf5 curl ];
  doCheck = true;

  meta = {
    description = "C++ API to manipulate netcdf files";
    homepage = "https://www.unidata.ucar.edu/software/netcdf/";
    license = lib.licenses.free;
    platforms = lib.platforms.unix;
  };
}
