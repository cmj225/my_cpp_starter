#include <Greeter/Greeter.h>

using namespace greeter;

Greeter::Greeter(std::string name) : _name(std::move(name)) {}

std::string Greeter::greet(LanguageCode lang) const {
  switch (lang) {
    default:
    case LanguageCode::EN:
      return "Hello " + _name;
    case LanguageCode::ED:
      return "Hallo	" + _name;
    case LanguageCode::ES:
      return "iHola " + _name;
    case LanguageCode::FR:
      return "Bonjour " + _name;
  }
}
