#include <greeter/greeter.h>

using namespace greeter;

Greeter::Greeter(std::string _name) : name(std::move(_name)) {}

std::string Greeter::greet(LanguageCode lang) const {
	switch (lang) {
		default:
		case LanguageCode::EN:
			return "Hello " + name;
	  case LanguageCode::ED:
			return "Hallo	" + name;
    case LanguageCode::ES:
			return "iHola " + name;
    case LanguageCode::FR:
			return "Bonjour " + name;
	}
}
